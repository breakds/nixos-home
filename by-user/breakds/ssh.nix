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

      # I want transient ssh connection for github since otherwise when I switch
      # the network github will hang there for a long period. Turning off the
      # control master can achieve this.
      "github.com" = {
        controlMaster = "no";
        controlPersist = "no";
      };

      "sisyphus" = {
        hostname = "161.189.132.45";
        port = 9000;
      };

      "bishop" = {
        hostname = "192.168.110.124";
        port = 22;
        proxyJump = "sisyphus";
      };

      "kami" = {
        hostname = "192.168.110.134";
        port = 22;
        proxyJump = "sisyphus";
      };

      "ares" = {
        hostname = "192.168.110.105";
        port = 22;
        proxyJump = "sisyphus";
      };

      "hades" = {
        hostname = "192.168.110.104";
        port = 22;
        proxyJump = "sisyphus";
      };

      "datahub" = {
        hostname = "192.168.110.223";
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

      "bmbj013" = mkBMBJ "123.56.73.0";
      "into-bmbj013" = mkIntoBMBJ "123.56.73.0";
      "bmbj014" = mkBMBJ "101.201.208.31";
      "into-bmbj014" = mkIntoBMBJ "101.201.208.31";
      "bmbj015" = mkBMBJ "47.93.183.132";
      "into-bmbj015" = mkIntoBMBJ "47.93.183.132";
      "bmbj016" = mkBMBJ "101.201.48.157";
      "into-bmbj016" = mkIntoBMBJ "101.201.48.157";
      "bmbj017" = mkBMBJ "101.200.139.34";
      "into-bmbj017" = mkIntoBMBJ "101.200.139.34";
      "bmbj018" = mkBMBJ "39.107.57.123";
      "into-bmbj018" = mkIntoBMBJ "39.107.57.123";
      "bmbj019" = mkBMBJ "101.201.211.109";
      "into-bmbj019" = mkIntoBMBJ "101.201.211.109";
      "bmbj020" = mkBMBJ "47.93.120.80";
      "into-bmbj020" = mkIntoBMBJ "47.93.120.80";
      "bmbj021" = mkBMBJ "47.93.183.3";
      "into-bmbj021" = mkIntoBMBJ "47.93.183.3";
      "bmbj022" = mkBMBJ "59.110.19.0";
      "into-bmbj022" = mkIntoBMBJ "59.110.19.0";

      "bmbj023" = mkBMBJ "8.147.107.42";
      "into-bmbj023" = mkIntoBMBJ "8.147.107.42";
      "bmbj024" = mkBMBJ "60.205.183.73";
      "into-bmbj024" = mkIntoBMBJ "60.205.183.73";
      "bmbj025" = mkBMBJ "101.201.57.70";
      "into-bmbj025" = mkIntoBMBJ "101.201.57.70";
      "bmbj026" = mkBMBJ "39.105.197.206";
      "into-bmbj026" = mkIntoBMBJ "39.105.197.206";
      "bmbj027" = mkBMBJ "47.94.46.127";
      "into-bmbj027" = mkIntoBMBJ "47.94.46.127";
      "bmbj028" = mkBMBJ "112.125.88.36";
      "into-bmbj028" = mkIntoBMBJ "112.125.88.36";
      "bmbj029" = mkBMBJ "39.105.102.23";
      "into-bmbj029" = mkIntoBMBJ "39.105.102.23";
      "bmbj030" = mkBMBJ "123.57.242.112";
      "into-bmbj030" = mkIntoBMBJ "123.57.242.112";
      "bmbj031" = mkBMBJ "182.92.104.37";
      "into-bmbj031" = mkIntoBMBJ "182.92.104.37";
    };
  };
}
