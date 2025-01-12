{ pkgs, lib, osConfig, ... }:

# Home Manager will pass osConfig as a module argument to any modules you
# create. This contains the system’s NixOS configuration.

let cfg = config.services.unison-remote-dev;

in {
  options.services.unison-remote-dev = with lib; {
    enable = mkEnableOption "Unison based remote development";
  };

  config = {
    # Always have unison installed. This is also required on the remote machine (i.e.
    # the server).
    home.packages = with pkgs; [
      unison
    ];

    systemd.user = lib.mkIf cfg.enable {
      services.unison-remote-dev-client = {
        Unit.Description = "Sync the local copy of repos to the corresponding remotes";
        service = {
          # Run those only when no other higher priority processes are ready to run.
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          Environment = [ "UNISON='${toString config.xdg.dataHome}/unison'" ];
        };
      };
    };
  };
}
