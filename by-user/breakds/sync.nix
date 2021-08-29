{ pkgs, lib, ... }:

let cloneRepo = { source, path } : lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "$HOME/${path}" ]]; then
        git clone ${source} $HOME/${path}
      fi
    '';

    sync-org = pkgs.callPackage ../../pkgs/sync-org {};

in {
  home.activation.initPasswordStore = cloneRepo {
    source = "git@github.com:breakds/PastOre.git";
    path = ".password-store";
  };

  home.activation.initEmacs = cloneRepo {
    source = "git@github.com:breakds/emacs.d.git";
    path = ".emacs.d";
  };

  home.activation.initOrg = cloneRepo {
    source = "git@github.com:breakds/org.git";
    path = "org";
  };

  systemd.user = {
    # Install the timer
    timers.sync-org-repo = {
      Unit.Description = "Sync my org to git server every now and then";
      Timer = {
        Unit = "sync-org-repo.service";
        # Run this every 10 seconds
        OnCalendar = "*-*-* *:2,12,22,32,42,52:00";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    # The service itself
    services.sync-org-repo = {
      Unit.Description = "Sync or with upstream on github";
      Service = {
        Type = "oneshot";
        ExecStart = "${sync-org}/bin/sync-org";
        WorkingDirectory = "/home/breakds";
      };
    };
  };
}
