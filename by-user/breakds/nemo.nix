{ config, lib, pkgs, ... }:

let
  extractZipToFolder = pkgs.writeShellScript "nemo-extract-zip-to-folder" ''
    archive="$1"
    exec ${pkgs.unzip}/bin/unzip -n -d "''${archive%.*}" "$archive"
  '';

  compressZip = pkgs.writeShellScript "nemo-compress-zip" ''
    set -eu
    cd -- "$1"
    shift
    files=( "''${@##*/}" )
    name="''${files[0]}"
    archive="$name.zip"
    suffix=1
    while [ -e "$archive" ]; do
      archive="$name ($suffix).zip"
      suffix=$((suffix + 1))
    done
    exec ${pkgs.zip}/bin/zip -r -nw "./$archive" -- "''${files[@]}"
  '';

  defaultBookmarks = pkgs.writeText "file-bookmarks" (lib.concatLines [
    "file://${config.home.homeDirectory}/syncthing/workspace/inbox inbox"
    "file://${config.home.homeDirectory}/syncthing/workspace workspace"
    "file://${config.home.homeDirectory}/syncthing/workspace/screenshots screenshots"
    "file://${config.home.homeDirectory}/syncthing/workspace/screenclips screenclips"
  ]);
in {
  home.packages = [ pkgs.nemo ];

  xdg.dataFile."nemo/actions/extract-zip.nemo_action".text = ''
    [Nemo Action]
    Name=Extract Here
    Exec=${pkgs.unzip}/bin/unzip -n -d %P %F
    Icon-Name=package-x-generic
    Selection=s
    Extensions=zip;
    Quote=double
    UriScheme=file
  '';

  xdg.dataFile."nemo/actions/extract-zip-to-folder.nemo_action".text = ''
    [Nemo Action]
    Name=Extract to %e/
    Exec=${extractZipToFolder} %F
    Icon-Name=package-x-generic
    Selection=s
    Extensions=zip;
    Quote=double
    UriScheme=file
  '';

  xdg.dataFile."nemo/actions/compress-zip.nemo_action".text = ''
    [Nemo Action]
    Name=Compress to ZIP
    Exec=${compressZip} %P %F
    Icon-Name=package-x-generic
    Selection=notnone
    Extensions=any;
    Quote=double
    UriScheme=file
  '';

  xdg.dataFile."icons/hicolor/scalable/apps/system-file-manager.svg".source =
    "${pkgs.nemo}/share/icons/hicolor/scalable/apps/nemo.svg";

  # Override folder handling in Niri without replacing other MIME preferences.
  xdg.configFile."niri-mimeapps.list".text = ''
    [Default Applications]
    inode/directory=nemo.desktop;
  '';

  # Nemo's launcher entry is already named "Files".
  xdg.desktopEntries."org.gnome.Nautilus" = {
    name = "Files (Nautilus)";
    exec = "${pkgs.nautilus}/bin/nautilus --new-window %U";
    noDisplay = true;
  };

  # Keep the file writable and preserve bookmarks and labels edited in Nemo.
  home.activation.seedFileBookmarks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.runtimeShell} -c ${lib.escapeShellArg ''
      bookmarks="${config.xdg.configHome}/gtk-3.0/bookmarks"
      mkdir -p "$(dirname "$bookmarks")"
      touch "$bookmarks"
      ${pkgs.gawk}/bin/awk '
        FILENAME == ARGV[1] { seen[$1] = 1; next }
        !seen[$1]++ { print }
      ' "$bookmarks" ${defaultBookmarks} >> "$bookmarks"
    ''}
  '';
}
