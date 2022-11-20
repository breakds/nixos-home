{ config, lib, pkgs, ... }:

let cfg = config.home.bds;

    lock = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p";

in {
  options.home.bds = with lib; {
    laptopXsession = mkOption {
      type = types.bool;
      description = "When set to true, enable graphical settings for laptop";
      default = false;
    };
  };

  config = {
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";

      windowManager.i3 = {
        enable = true;

        # Use the i3-gaps instead of the stock i3
        package = pkgs.i3-gaps;

        # Use Windows/Command key as the modifier
        config = rec {
          modifier = "Mod4";
          terminal = "${pkgs.alacritty}/bin/alacritty";
          menu = "${pkgs.rofi}/bin/rofi -show drun";

          fonts = {
            names = [ "RobotoMono" "FontAwesome" ];
            size = 9.0;
          };

          gaps = {
            inner = 6;
            smartGaps = true;
            smartBorders = "on";
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
            "${modifier}+Shift+e" =
              "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

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

          bars = [{
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-bottom.toml";
          }];
        };
      };
    };

    # This will generate $HOME/.config/i3status-rust/config.toml
    programs.i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          theme = "slick";
          icons = "awesome";
          blocks = (lib.lists.optionals cfg.laptopXsession [
            {
              block = "backlight";
              invert_icons = true;
            }
          ]) ++ [
            {
              block = "disk_space";
              path = "/";
              alias = "/";
              info_type = "available";
              format = "{icon} {available} / {total}";
              unit = "GB";
              interval = 30;
              warning = 20.0;
              alert = 10.0;
            }

            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used}";
            }

            {
              block = "cpu";
              interval = 1;
              format = "{utilization}";
            }

            {
              block = "sound";
            }

            {
              block = "time";
              interval = 30;
              format = "%a %d/%m %R";
            }
          ] ++ (lib.lists.optionals cfg.laptopXsession [
            {
              block = "battery";
              interval = 15;
            }
          ]);
        };
      };
    };
  };
}
