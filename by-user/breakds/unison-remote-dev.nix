{ pkgs, lib, config, osConfig, ... }:

# Home Manager will pass osConfig as a module argument to any modules you
# create. This contains the system’s NixOS configuration.

let allClientRoots = {
      "hand" = [ "PersonaX@malenia-home" "beancounting@malenia-home" ];
      "ghostberry" = [
        "intraday-alpha-research@hades"
        "research-toolkit@hades"
        "deployhub@hades"
      ];
    };

    clientRoots = if builtins.hasAttr osConfig.networking.hostName allClientRoots
                  then builtins.getAttr osConfig.networking.hostName allClientRoots
                  else [];

    enabled = (lib.length clientRoots) > 0;

in {
  config = {
    # Always have unison installed. This is also required on the remote machine (i.e.
    # the server).
    home.packages = with pkgs; [
      unison
    ];

    home.activation.prepareLocal = lib.mkIf enabled (
      let localPaths = lib.strings.concatMapStringsSep " " (
            x: "'/home/breakds/projects/remotes/${x}'") clientRoots;
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        for path in ${localPaths}; do
          if [[ ! -d $path ]]; then
            mkdir -p $path
          fi
        done
      '');

    services.unison = lib.mkIf enabled {
      enable = true;
      # Note that this requires `unison` installed on the remote machine. Can just
      # add it in `home.packages`.
      pairs = lib.foldl' (acc: localName: let
        parts = lib.strings.splitString "@" localName;
        originalName = lib.elemAt parts 0;
        remoteHost = lib.elemAt parts 1;
      in acc // {
        "${localName}" = {
          roots = [
            "/home/breakds/projects/remotes/${localName}"
            "ssh://${remoteHost}//home/breakds/projects/${originalName}"
          ];
        };
      }) {} clientRoots;
    };
  };
}
