{ config, lib, pkgs, ... }:

let cfg = config.home.bds;

    lock = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p";

in {
  imports = [
    ./i3.nix
    ./sway.nix
  ];

  options.home.bds = with lib; {
    windowManager = mkOption {
      type = types.enum [ "i3" "sway" ];
      default = "i3";
      description = ''
        Which window manager to use by the home manager session.
      '';
    };

    laptopXsession = mkOption {
      type = types.bool;
      description = "When set to true, enable graphical settings for laptop";
      default = false;
    };
  };

  config = {
    xsession.enable = true;
    xsession.scriptPath = ".hm-xsession";
  };
}
