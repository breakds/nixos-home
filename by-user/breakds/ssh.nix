{ config, pkgs, lib, ... }:

let cfg = config.home.bds;

    mkOffice = ip: {
      HostName = ip;
      Port = 22;
      ForwardAgent = true;
    };

    mkIntoOffice = ip: {
      HostName = ip;
      Port = 22;
      ProxyJump = "sisyphus";
      ForwardAgent = true;
    };

    mkIntoXixin = ip: {
      HostName = ip;
      Port = 22;
      ProxyJump = "xx-gateway";
      ForwardAgent = true;
    };

    # Universally useful ssh match blocks
    baseBlocks = {
      "*" = {
        IdentityFile = "~/.ssh/breakds_malenia";
        HashKnownHosts = true;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ForwardAgent = false;  # explicitly set what default used to be
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;

        # The master connection will automatically close if it has been idle for
        # more than 10 minutes.
        #
        # I want transient ssh connection for github since otherwise when I switch
        # the network github will hang there for a long period. Turning off the
        # control master can achieve this.
        ControlMaster = "auto";        
        ControlPersist = "600s";
        ControlPath = "~/.ssh/cm-%C";
      };

      "sisyphus" = {
        HostName = "161.189.132.45";
        Port = 9000;
      };

      "octavian" = {
        HostName = "10.77.1.130";
      };

      "xx-gateway" = {
        HostName = "118.116.4.4";
        Port = 9000;
        User = "wonder";
      };

      "malenia-home" = {
        HostName = "10.77.1.185";
      };

      "into-malenia" = {
        HostName = "10.77.1.185";
        ProxyJump = "www.breakds.org";
      };

      "tailto-malenia" = {
        HostName = "10.77.1.185";
        ProxyJump = "100.118.233.13";  # via tailscale exit node
      };

      "into-lorian" = {
        HostName = "10.77.1.128";
        ProxyJump = "www.breakds.org";
      };

      "limbius" = {
        HostName = "10.77.1.193";
        User = "breakds";
      };

      "pilot1" = {
        HostName = "52.52.216.115";
        User = "breakds";
      };

      "cradle1" = {
        HostName = "50.18.30.229";
        User = "breakds";
      };

      "into-pilot1" = {
        HostName = "52.52.216.115";
        ProxyJump = "www.breakds.org";
      };

      "into-cradle1" = {
        HostName = "50.18.30.229";
        ProxyJump = "www.breakds.org";
      };

      "hermes.researcher" = {
        HostName = "10.80.1.3";
        User = "hermes";
        ProxyJump = "root@10.77.1.136";
      };

      "hermes.psynker" = {
        HostName = "10.80.1.4";
        User = "hermes";
        ProxyJump = "root@10.77.1.136";
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
        HostName = "ssh.github.com";
        Port = 443;
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

      settings = lib.mkMerge [
        baseBlocks
        chengduBlocks
        ({
          "github.com" = {
            ControlPersist = "30s";
          };
        })
      ];
    };
  };
}
