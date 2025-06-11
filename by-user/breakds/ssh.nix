{ config, pkgs, lib, ... }:

let cfg = config.home.bds;

    mkOffice = ip: {
      hostname = ip;
      port = 22;
      forwardAgent = true;
      # Automatically forward 28888 back to the client, for e.g. jupyter lab purpose.
      localForwards = [{
        bind.address = "localhost";
        bind.port = 28888;
        host.address = "localhost";
        host.port = 28888;
      }];
    };

    mkIntoOffice = ip: {
      hostname = ip;
      port = 22;
      proxyJump = "sisyphus";
      forwardAgent = true;
    };

    mkIntoXixin = ip: {
      hostname = ip;
      port = 22;
      proxyJump = "xx-gateway";
      forwardAgent = true;
    };

    # Universally useful ssh match blocks
    baseBlocks = {
      "*" = {
        identityFile = "~/.ssh/breakds_samaritan";
      };

      "sisyphus" = {
        hostname = "161.189.132.45";
        port = 9000;
      };

      "octavian" = {
        hostname = "10.77.1.130";
      };

      "xx-gateway" = {
        hostname = "118.116.4.4";
        port = 9000;
        user = "wonder";
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

      "limbius" = {
        hostname = "10.77.1.193";
        user = "breakds";
      };

      "into-bishop" = mkIntoOffice "192.168.110.124";
      "into-kami" = mkIntoOffice "192.168.110.134";
      "into-ares" = mkIntoOffice "192.168.110.105";
      "into-hades" = mkIntoOffice "192.168.110.104";
      "into-lothric" = mkIntoOffice "192.168.110.30";
      "into-thor" = mkIntoOffice "192.168.110.138";
      "into-datahub" = mkIntoOffice "192.168.110.223";

      "into-xx-database-1" = mkIntoXixin "192.168.120.207";
      "into-xx-monitor" = mkIntoXixin "192.168.120.179";
      "into-xx-cardinal" = mkIntoXixin "192.168.120.204";
    };

    # Location dependent entries for "chengdu"
    chengduBlocks = lib.mkIf (cfg.location == "chengdu") {
      # Specific requirement for China
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };

      "lothric" = mkOffice "192.168.110.30";
      "bishop" = mkOffice "192.168.110.124";
      "kami" = mkOffice "192.168.110.134";
      "ares" = mkOffice "192.168.110.105";
      "hades" = mkOffice "192.168.110.104";
      "datahub" = mkOffice "192.168.110.223";
    };

    # Location dependent entries for ""
    valleyBlocks = lib.mkIf (cfg.location == "valley") {
      "gpudev-005" = {
        hostname = "39.101.198.43";
        port = 6200;
        user = "yiqing.yang";
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
    };

in {
  options.home.bds = with lib; {
    location = mkOption {
      type = types.enum [ "valley" "chengdu" ];
      default = "valley";
      description = ''
        Specify the location where the machine is physically located.
        For example, ssh jump proxies may depend on this.
      '';
    };
  };

  config = {

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;
      controlMaster = "auto";
      # The master connection will automatically close if it has been idle for
      # more than 10 minutes.
      #
      # I want transient ssh connection for github since otherwise when I switch
      # the network github will hang there for a long period. Turning off the
      # control master can achieve this.
      controlPersist = "30s";

      # TODO(breakds): Setup Agent Forwarding

      matchBlocks = lib.mkMerge [
        baseBlocks
        valleyBlocks
        chengduBlocks
      ];
    };
  };
}
