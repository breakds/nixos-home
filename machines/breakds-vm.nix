{ config, pkgs, ... }:

{
  config = {
    users.users."breakds" = {
      isNormalUser = true;
      initialPassword = "I_AM_GROOT";
      home = "/home/breakds";
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    home-manager.users.breakds.home.stateVersion = "22.05"; 
  };
}
