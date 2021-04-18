{ config, pkgs, ... }:

{
  config = {
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
  };
}
