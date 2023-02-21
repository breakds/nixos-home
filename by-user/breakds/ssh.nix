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

      "octavian" = {
        hostname = "10.77.1.130";
      };

      "malenia-home" = {
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

      "into-malenia" = {
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

      "armlet" = {
        hostname = "10.77.1.188";
        user = "breakds";
      };

      "into-gail3" = {
        hostname = "gail3.breakds.org";  # 10.40.0.173
        proxyJump = "armlet";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "into-samaritan" = {
        hostname = "samaritan.breakds.org";  # 10.40.1.52
        proxyJump = "armlet";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "gail3" = {
        hostname = "gail3.breakds.org";  # 10.40.0.173
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "samaritan" = {
        hostname = "samaritan.breakds.org";  # 10.40.1.52
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "into-ali" = {
        hostname = "39.105.219.118";  # 10.40.1.52
        proxyJump = "armlet";
        port = 50022;
        user = "yiqing.yang";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
