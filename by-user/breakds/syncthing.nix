{ config, lib, ... }:

{
  config = lib.mkIf config.services.syncthing.enable {
    services.syncthing = {
      overrideDevices = true;
      overrideFolders = true;
      guiAddress = "127.0.0.1:8384";

      settings = {
        devices = {
          # Discovery finds peers; their IDs verify their identities.
          "hand" = {
            id =
              "HDUZ6E3-ZMKCKOU-H6EYUET-XZ72BBU-547J5H2-BFEZFWM-DRX5YIR-23Z6TAH";
          };
          "malenia" = {
            id =
              "RO54QTU-EJBHNA6-7IEMT2A-57UBFYH-N2USR7J-UN6A2ZL-G4W4AIV-DUFACAF";
          };
          "brock" = {
            id =
              "2O6IE5U-2OGL2ZB-LO44JKX-LB6ZIFO-4JDRC34-HSIEAMX-VW4CN5G-IZGOKAZ";
          };
          "claw" = {
            id =
              "SPXDVPN-CDZOWPP-I2QKYOD-3PNV4BZ-YH2S7OL-RSEM7LC-CKJ6DCL-AUSATAS";
          };
          "grapple" = {
            id =
              "JEXYKVV-PL5TIBV-OHDNCRN-BXCYDRJ-DSQXPZD-T7NUE7Z-JRS44FU-QVXBKAV";
          };
        };

        folders.workspace = {
          path = "${config.home.homeDirectory}/syncthing/workspace";
          devices = [ "hand" "claw" "malenia" "brock" "grapple" ];
          ignorePerms = true;
          rescanIntervalS = 3600;
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
      };
    };

    # Reuse the NixOS service's keys, config, and database in place. Both
    # services must resolve the same directory, including the API key lookup.
    systemd.user.services.syncthing.Service.Environment =
      [ "XDG_STATE_HOME=${config.home.homeDirectory}/syncthing/.config" ];
    systemd.user.services.syncthing-init.Service.Environment =
      [ "XDG_STATE_HOME=${config.home.homeDirectory}/syncthing/.config" ];
  };
}
