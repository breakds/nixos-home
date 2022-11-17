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

      "kami" = {
        hostname = "192.168.110.111";
        port = 22;
        proxyJump = "sisyphus";
      };

      "richelieu" = {
        hostname = "10.77.1.121";
      };

      "samaritan-home" = {
        hostname = "10.77.1.185";
        localForwards = [
          {
            bind.port = 8888;
            host.address = "localhost";
            host.port = 8888;
          }
        ];
        forwardX11 = true;
        forwardX11Trusted = true;
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
        forwardX11Trusted = true;
      };

      "into-lorian" = {
        hostname = "10.77.1.128";
        proxyJump = "www.breakds.org";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "into-lothric" = {
        hostname = "10.77.1.127";
        proxyJump = "www.breakds.org";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "gpudev-005" = {
        hostname = "39.101.198.43";
        port = 6200;
        user = "yiqing.yang";
      };

      "zero" = {
        hostname = "10.77.1.221";
        user = "breakds";
      };

      "gail3" = {
        hostname = "gail3.breakds.org";
        proxyJump = "zero";
      };
    };
  };
}
