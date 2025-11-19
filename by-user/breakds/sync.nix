{ pkgs, lib, ... }:

# 1. Placed after `writeBoundary` because the block may have side
#    effect of creating new files.
#
# 2. Need to specify a ssh binary to use
let cloneRepo = { source, path } : lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "$HOME/${path}" ]]; then
        GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -i /home/breakds/.ssh/breakds_malenia -o IdentitiesOnly=yes" ${pkgs.git}/bin/git clone ${source} $HOME/${path}
      fi
    '';

    clonePythonTypeStubs = { source, path } : lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "$HOME/.local/share/pytypestubs/${path}" ]]; then
        mkdir -p $HOME/.local/share/pytypestubs
        GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -i /home/breakds/.ssh/breakds_malenia -o IdentitiesOnly=yes" ${pkgs.git}/bin/git clone ${source} \
          $HOME/.local/share/pytypestubs/${path}
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

  home.activation.cloneTypeshed = clonePythonTypeStubs {
    source = "https://github.com/python/typeshed";
    path = "typeshed";
  };

  home.activation.cloneMSPythonTypeStubs = clonePythonTypeStubs {
    source = "https://github.com/microsoft/python-type-stubs";
    path = "python-type-stubs";
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
