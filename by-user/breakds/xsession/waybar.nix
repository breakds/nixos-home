{ config, lib, pkgs, ... }: let
  name = "breakds";

  # custom colors
  foreground = "#C6D0F5";   # text
  background = "#303446";   # base
  regular0   = "#DFDFDF";   # papirus
  regular1   = "#E78284";   # red
  regular2   = "#A6D189";   # green
  regular3   = "#E5C890";   # yellow
  regular4   = "#8CAAEE";   # blue
  regular5   = "#F4B8E4";   # pink
  regular6   = "#81C8BE";   # teal
  regular7   = "#F2D5CF";   # rosewater
  regular8   = "#EEBEBE";   # flamingo
  regular9   = "#CA9EE6";   # mauve
  regular10  = "#EA999C";   # maroon
  regular11  = "#EF9F76";   # peach
  regular12  = "#81C8BE";   # teal
  regular13  = "#99D1DB";   # sky
  regular14  = "#85C1DC";   # sapphire
  regular15  = "#BABBF1";   # lavender

in {
  config = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          position = "bottom";
          height = 24;
          spacing = 0;
          output = [
            "eDP-1"
          ];
          modules-left = [
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "bluetooth"
            "network"
            "pulseaudio"
            "backlight"
            "cpu"
            "memory"
            "battery"
            "tray"
          ];
          "keyboard-state" = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            on-click = "activate";
            all-outputs = true;
            disable-scroll = true;
            sort-by-number = true;
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";
            };
            persistent-workspaces = {};
          };
          "sway/scratchpad" = {
            format = "{icon} {count}";
            show-empty = false;
            format-icons = [
              ""
              ""
            ];
            tooltip = true;
            tooltip-format = "{app}: {title}";
          };
          "sway/window" = {
            max-length = 30;
          };
          "bluetooth" = {
            format = "{status} ";
            format-disabled = "";
            format-connected = "{num_connections} connected ";
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          };
          "mpd" = {
            format = "{stateIcon} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
            format-disconnected = "Disconnected ";
            format-stopped = "{randomIcon}Stopped ";
            unknown-tag = "N/A";
            interval = 2;
            consume-icons = {
              "on" = " ";
            };
            random-icons = {
              off = "<span color=\"#f53c3c\"></span> ";
              on = " ";
            };
            repeat-icons = {
              on = "";
            };
            single-icons = {
              on = " ";
            };
            state-icons = {
              paused = "";
              playing = "";
            };
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };
          "tray" = {
            icon-size = 13;
            spacing = 8;
          };
          "clock" = {
            interval = 60;
            tooltip = false;
            format = "{:%d.%m.%Y  %H:%M }";
          };
          "cpu" = {
            format = "{usage}% ";
            tooltip =false;
          };
          "memory" = {
            format = "{}% ";
          };
          "temperature" = {
            # thermal-zone" = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            # format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
            ];
          };
          "backlight" = {
            # device = "acpi_video1";
            format = "{percent}% {icon}";
            format-icons = [
              "" "" "" "" "" "" "" "" "" "" ""
            ];
          };
          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            interval = 2;
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            # "format-good": ""; # An empty format will hide the module
            # "format-full": "";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "network" = {
            # "interface" = "wlp2*"; # (Optional) To force the use of this interface
            format-wifi = "{signalStrength}% ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{ifname} = {ipaddr}/{cidr} ";
          };
          "pulseaudio" = {
            # "scroll-step" = 1; # %; can be a float
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = "{volume}%  {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "{volume}% ";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                "" "" ""
              ];
            };
          };
        };
      };
      style = ''
            * {
              font-family: FontAwesome, Monospace;
              font-size: 12px;
            }

            window#waybar {
              color: ${foreground};
              background-color: ${background};
              border-bottom: 3px solid ${regular4};
              transition-property: background-color;
              transition-duration: .5s;
          }

            window#waybar.hidden {
              opacity: 0.2;
        }

            /*
            window#waybar.empty {
              background-color: transparent;
            }
            window#waybar.solo {
              background-color: ${regular4};
            }
            */

            window#waybar.termite {
              background-color: ${regular4};
            }

            window#waybar.chromium {
              background-color: ${regular4};
              border: none;
            }

            button {
              box-shadow: inset 0 -3px transparent;
              border: none;
              border-radius: 0;
            }

            button:hover {
              background: inherit;
              box-shadow: inset 0 -3px ${foreground};
            }

            #workspaces button {
              padding: 0 5px;
              background-color: #D0E2FF;
            }

            #workspaces button:hover {
              background: rgba(0, 0, 0, 0.2);
            }

            #workspaces button.focused {
              background-color: ${regular4};
              box-shadow: inset 0 -3px ${foreground};
            }

            #workspaces button.urgent {
              background-color: ${regular1};
            }

            #mode {
              color: ${regular0};
              background-color: ${regular4};
              border-bottom: 3px solid ${foreground};
            }

            #clock,
            #battery,
            #bluetooth,
            #cpu,
            #memory,
            #disk,
            #temperature,
            #backlight,
            #network,
            #pulseaudio,
            #wireplumber,
            #tray,
            #mode,
            #mpd {
              padding: 0 10px;
            }

            #window,
            #workspaces {
              margin: 0 4px;
            }

            .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
            }

            .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
            }

            #clock {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular13};
            }

            #battery {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular6};
            }

            #battery.charging, #battery.plugged {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular6};
            }

            @keyframes blink {
              to {
                color: ${regular0};
                background-color: transparent;
                border-bottom: 3px solid ${regular6};
              }
            }

            #battery.critical:not(.charging) {
              color: ${regular0};
              background-color: ${regular1};
              border-bottom: 3px solid ${regular6};
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }

            #bluetooth {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular8};
            }

            label:focus {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular4};
            }

            #cpu {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular3};
            }

            #memory {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular11};
            }

            #disk {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular12};
            }

            #backlight {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular5};
            }

            #network {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular10};
            }

            #network.disconnected {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular3};
            }

            #pulseaudio {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular2};
            }

            #pulseaudio.muted {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular2};
            }

            #wireplumber {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular2};
            }

            #wireplumber.muted {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular2};
            }

            #temperature {
              color: ${regular0};
              background-color: transparent;
              border-bottom: 3px solid ${regular7};
            }

            #temperature.critical {
              background-color: transparent;
              border-bottom: 3px solid ${regular7};
            }

            #tray {
              background-color: transparent;
              border-bottom: 3px solid ${regular9};
            }

            #tray > .passive {
              -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: transparent;
              border-bottom: 3px solid ${regular14};
            }

            #mpd {
              background-color: transparent;
              border-bottom: 3px solid ${regular15};
            }

            #mpd.disconnected {
              background-color: transparent;
              border-bottom: 3px solid ${regular15};
            }

            #mpd.stopped {
              background-color: transparent;
              border-bottom: 3px solid ${regular15};
            }

            #mpd.paused {
              background-color: transparent;
              border-bottom: 3px solid ${regular15};
            }
          '';
    };
  };
}
