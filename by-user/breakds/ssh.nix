{ pkgs, ... }:

let mkBMBJ = ip: {
      hostname = ip;
      port = 50022;
      user = "yiqing.yang";
    };

    mkIntoBMBJ = ip: {
      hostname = ip;
      proxyJump = "into-samaritan";
      port = 50022;
      user = "yiqing.yang";
    };

in {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    controlMaster = "auto";
    # The master connection will automatically close if it has been idle for
    # more than 10 minutes.
    controlPersist = "10m";

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

      "ares" = {
        hostname = "192.168.110.105";
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

      "tailto-malenia" = {
        hostname = "10.77.1.185";
        proxyJump = "100.118.233.13";  # via tailscale exit node
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

      "limbius" = {
        hostname = "10.77.1.193";
        user = "breakds";
      };

      "into-gail3" = {
        hostname = "gail3.breakds.org";  # 10.40.0.173
        proxyJump = "limbius";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "into-samaritan" = {
        hostname = "samaritan.breakds.org";  # 10.40.1.52
        proxyJump = "limbius";
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

      "into-radahn" = {
        hostname = "radahn.breakds.org";  # 10.40.1.104
        proxyJump = "limbius";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "radahn" = {
        hostname = "radahn.breakds.org";  # 10.40.1.104
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "into-ali" = {
        hostname = "39.105.219.118";
        proxyJump = "limbius";
        port = 50022;
        user = "yiqing.yang";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "bmbj001" = mkBMBJ "39.105.219.118";
      "into-bmbj001" = mkIntoBMBJ "39.105.219.118";
      "bmbj002" = mkBMBJ "39.106.85.150";
      "into-bmbj002" = mkIntoBMBJ "39.106.85.150";
      "bmbj003" = mkBMBJ "39.107.81.216";
      "into-bmbj003" = mkIntoBMBJ "39.107.81.216";
      "bmbj004" = mkBMBJ "39.105.129.73";
      "into-bmbj004" = mkIntoBMBJ "39.105.129.73";
      "bmbj005" = mkBMBJ "39.105.183.19";
      "into-bmbj005" = mkIntoBMBJ "39.105.183.19";
      "bmbj006" = mkBMBJ "39.107.255.19";
      "into-bmbj006" = mkIntoBMBJ "39.107.255.19";
      "bmbj007" = mkBMBJ "39.105.218.151";
      "into-bmbj007" = mkIntoBMBJ "39.105.218.151";
      "bmbj008" = mkBMBJ "47.94.21.167";
      "into-bmbj008" = mkIntoBMBJ "47.94.21.167";
      "bmbj009" = mkBMBJ "59.110.171.241";
      "into-bmbj009" = mkIntoBMBJ "59.110.171.241";
      "bmbj010" = mkBMBJ "101.201.35.69";
      "into-bmbj010" = mkIntoBMBJ "101.201.35.69";
      "bmbj011" = mkBMBJ "101.200.195.73";
      "into-bmbj011" = mkIntoBMBJ "101.200.195.73";
      "bmbj012" = mkBMBJ "123.56.239.29";
      "into-bmbj012" = mkIntoBMBJ "123.56.239.29";
    };
  };
}
