{ config, lib, pkgs, ... }:

let cfg = config.home.bds;

in {
  config = lib.mkIf (cfg.windowManager == "sway") {
    wayland.windowManager.sway = {
      enable = true;

      # package = pkgs.swayfx;

      # Use Windows/Command key as the modifier
      config = rec {
        modifier = "Mod4";
        terminal = "${config.programs.wezterm.package}/bin/wezterm";
        menu = "${pkgs.rofi}/bin/rofi -show drun";

        bars = [{
          command = "${pkgs.waybar}/bin/waybar";
        }];

        focus = {
          forceWrapping = false;
        };

        fonts = {
          names = [ "RobotoMono" "FontAwesome" ];
          size = 9.0;
        };

        gaps = {
          inner = 6;
          smartGaps = true;
          smartBorders = "on";
        };

        input = {
          # Although we specify "*" here, the following settings will only be
          # effective for the libinput compatible touchpads.
          "*" = {
            click_method = "clickfinger";  # 1 finger = left, 2 finger = right
            tap = "enabled";               # tapping as click
            dwt = "enabled";               # disable while typing
            dwtp = "enabled";              # disable while trackpointing
          };
        };

        startup = [
          { command = "${pkgs.autotiling}/bin/autotiling"; }
          { command = "${pkgs.wpaperd}/bin/wpaperd"; }
          # This is for non-wayland-native applications such as chrome and
          # emacs. For them, we use "Xft.dpi" to scale, which is defined in
          # "~/.Xresources". This command force activate it.
          { command = "${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources"; }
        ];

        window = {
          titlebar = true;
        };

        keybindings = lib.mapAttrs (binding: lib.mkOptionDefault) {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+p" = "exec ${pkgs.rofi-pass-wayland}/bin/rofi-pass";
          "${modifier}+Shift+b" = "exec ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth";

          "${modifier}+j" = "focus left";
          "${modifier}+k" = "focus down";
          "${modifier}+l" = "focus up";
          "${modifier}+semicolon" = "focus right";

          # Alternatively, you can use the cursor keys.
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+j" = "move left";
          "${modifier}+Shift+k" = "move down";
          "${modifier}+Shift+l" = "move up";
          "${modifier}+Shift+semicolon" = "move right";

          # Alternatively, you can use the cursor keys.
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+a" = "focus parent";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Shift+1" =
            "move container to workspace number 1";
          "${modifier}+Shift+2" =
            "move container to workspace number 2";
          "${modifier}+Shift+3" =
            "move container to workspace number 3";
          "${modifier}+Shift+4" =
            "move container to workspace number 4";
          "${modifier}+Shift+5" =
            "move container to workspace number 5";
          "${modifier}+Shift+6" =
            "move container to workspace number 6";
          "${modifier}+Shift+7" =
            "move container to workspace number 7";
          "${modifier}+Shift+8" =
            "move container to workspace number 8";
          "${modifier}+Shift+9" =
            "move container to workspace number 9";
          "${modifier}+Shift+0" =
            "move container to workspace number 10";

          "${modifier}+x" = "mode session";
          "${modifier}+r" = "mode resize";
        };

        modes = {
          resize = {
            Escape = "mode default";
            Return = "mode default";
            "j" = "resize shrink width 10 px or 10 ppt";
            "k" = "resize grow height 10 px or 10 ppt";
            "l" = "resize shrink height 10 px or 10 ppt";
            "semicolon" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
          };

          session = {
            Escape = "mode default";
            Return = "mode default";
            "e" = "exec swaymsg exit, mode default";
            "l" = "exec swaylock, mode default";
            "c" = "reload";
            "r" = "exec systemctl reboot, mode default";
            "p" = "exec systemctl poweroff, mode default";
          };

        };
      };

      swaynag = {
        enable = true;
        settings = {
          "<config>" = {
            edge = "top";
            font = "Monospace 8";
            background = "af69ef";
            message-padding = 10;
          };
        };
      };
    };

    programs.rofi = {
      enable = true;
      font = "Monospace 8";

      extraConfig = {
        case-sensitive = false;
        display-drun = "Apps:";
        modi = [ "drun" "run" ];
        show-icons = false;
      };

      pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
        stores = [ "~/.password-store" ];
      };

      plugins = with pkgs; [
        rofi-bluetooth
        rofi-pulse-select
      ];
    };

    # https://git.sr.ht/~hervyqa/swayhome/tree/HEAD/item/home/programs/swaylock.nix
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        bs-hl-color = "F2D5CF";
        caps-lock-bs-hl-color = "F2D5CF";
        caps-lock-key-hl-color = "A6D189";
        color = "303446";
        inside-caps-lock-color = "00000000";
        inside-clear-color = "00000000";
        inside-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "A6D189";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "C6D0F5";
        line-caps-lock-color = "00000000";
        line-clear-color = "00000000";
        line-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-caps-lock-color = "EF9F76";
        ring-clear-color = "F2D5CF";
        ring-color = "BABBF1";
        ring-ver-color = "8CAAEE";
        ring-wrong-color = "EA999C";
        separator-color = "00000000";
        text-caps-lock-color = "EF9F76";
        text-clear-color = "F2D5CF";
        text-color = "C6D0F5";
        text-ver-color = "8CAAEE";
        text-wrong-color = "EA999C";
        font = "Monospace";
        font-size = 12;
        disable-caps-lock-text = true;
        ignore-empty-password = true;
        indicator = true;
        indicator-caps-lock = true;
        indicator-radius = 50;
        indicator-thickness = 10;
        screenshots = true;
        clock = true;
        effect-blur = "7x5";
        effect-vignette = "0.5:0.5";
        grace = "2";
        fade-in = "0.2";
      };
    };

    programs.wpaperd = {
      enable = true;
      settings.default = {
        duration = "2m";
        path = "/home/breakds/Pictures/wallpapers";
        sortign = "ascending";
        apply-shadow = false;
      };
    };

    home.packages = with pkgs; [
      wayland-utils
      wl-clipboard
      mako
    ];
  };
}
