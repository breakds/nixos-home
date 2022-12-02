{ config, pkgs, ... }:

{
  config = {
    nixpkgs.config.allowUnfree = true;
    users.users."cassandra" = {
      isNormalUser = true;
      initialPassword = "I_AM_GROOT";
      home = "/home/cassandra";
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
    home-manager.users.cassandra.home.stateVersion = "22.05";     
  };
}
