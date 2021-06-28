{ pkgs, lib, ... }:

let cloneRepo = { source, path } : lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "$HOME/${path}" ]]; then
        git clone ${source} $HOME/${path}
      fi
    '';

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
}
