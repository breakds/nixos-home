{ config, lib, pkgs, ... }:

let cfg = config.home.bds;

    lock = "${pkgs.swaylock-effects}/bin/swaylock-effects --screenshots --clock";

in {
  config = lib.mkIf (cfg.windowManager == "sway") {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

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

        startup = [
          { command = "${pkgs.autotiling}/bin/autotiling"; }
          { command = "${pkgs.wpaperd}/bin/wpaperd"; }
        ];

        window = {
          titlebar = true;
        };

        keybindings = lib.mapAttrs (binding: lib.mkOptionDefault) {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+x" = "exec ${lock}";

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

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+r" = "mode resize";
        };

        modes = {
          "resize" = {
            "j" = "resize shrink width 10 px or 10 ppt";
            "k" = "resize grow height 10 px or 10 ppt";
            "l" = "resize shrink height 10 px or 10 ppt";
            "semicolon" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
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

      # TODO(breakds): Add password store support

      plugins = with pkgs; [
        rofi-bluetooth
        rofi-pulse-select
      ];
    };
  };
}
