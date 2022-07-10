{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    controlMaster = "auto";

    # TODO(breakds): Setup Agent Forwarding

    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/breakds_samaritan";
      };

      "sisyphus" = {
        hostname = "161.189.132.45";
        port = 9000;
      };

      "bishop" = {
        hostname = "192.168.110.161";
        port = 22;
        proxyJump = "sisyphus";
      };

      "richelieu" = {
        hostname = "10.77.1.121";
      };

      "into-samaritan" = {
        hostname = "10.77.1.185";
        proxyJump = "www.breakds.org";
        localForwards = [
          {
            bind.port = 8888;
            host.address = "localhost";
            host.port = 8888;
          }
        ];
        forwardX11 = true;
      };
      
      "gpudev-005" = {
        hostname = "39.101.198.43";
        port = 6200;
        user = "yiqing.yang";
      };
    };
  };
}
