{ config, pkgs, lib, ... }:

let cfg = config.home.bds;

    mkOffice = ip: {
      hostname = ip;
      port = 22;
      forwardAgent = true;
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
        identityFile = "~/.ssh/breakds_malenia";
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        forwardAgent = false;  # explicitly set what default used to be
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;

        # The master connection will automatically close if it has been idle for
        # more than 10 minutes.
        #
        # I want transient ssh connection for github since otherwise when I switch
        # the network github will hang there for a long period. Turning off the
        # control master can achieve this.
        controlMaster = "auto";        
        controlPersist = "600s";
        controlPath = "~/.ssh/cm-%C";
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
      };

      "into-malenia" = {
        hostname = "10.77.1.185";
        proxyJump = "www.breakds.org";
      };

      "tailto-malenia" = {
        hostname = "10.77.1.185";
        proxyJump = "100.118.233.13";  # via tailscale exit node
      };

      "into-lorian" = {
        hostname = "10.77.1.128";
        proxyJump = "www.breakds.org";
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
      enableDefaultConfig = false;
      # TODO(breakds): Setup Agent Forwarding

      matchBlocks = lib.mkMerge [
        baseBlocks
        chengduBlocks
        ({
          "github.com" = {
            controlPersist = "30s";
          };
        })
      ];
    };
  };
}
