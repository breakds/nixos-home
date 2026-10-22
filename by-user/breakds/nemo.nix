{ config, lib, pkgs, ... }:

let
  defaultBookmarks = pkgs.writeText "file-bookmarks" (lib.concatLines [
    "file://${config.home.homeDirectory}/syncthing/workspace/inbox inbox"
    "file://${config.home.homeDirectory}/syncthing/workspace workspace"
    "file://${config.home.homeDirectory}/syncthing/workspace/screenshots screenshots"
    "file://${config.home.homeDirectory}/syncthing/workspace/screenclips screenclips"
  ]);
in {
  home.packages = [ pkgs.nemo ];

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
