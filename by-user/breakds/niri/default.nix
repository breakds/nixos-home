{ config, lib, pkgs, ... }:

let
  niri-session-menu = pkgs.writeShellScriptBin "niri-session-menu" ''
    choice=$(printf "lock\nexit\nreboot\npoweroff" | ${pkgs.fuzzel}/bin/fuzzel --dmenu -p "Session: ")
    case "$choice" in
      lock) noctalia-shell ipc call lockScreen lock ;;
      exit) niri msg action quit ;;
      reboot) systemctl reboot ;;
      poweroff) systemctl poweroff ;;
    esac
  '';

  niri-screen-record = pkgs.writeShellApplication {
    name = "niri-screen-record";
    runtimeInputs = with pkgs; [ procps slurp wl-screenrec ];
    text = ''
      if pgrep -x wl-screenrec > /dev/null; then
        pkill -x wl-screenrec
      else
        mkdir -p "$HOME/Videos"
        filename="$(hostname)_$(date +%Y%m%d_%H%M%S).mp4"
        geometry="$(slurp)"
        if [ -n "$geometry" ]; then
          wl-screenrec --low-power=off -g "$geometry" -f "$HOME/Videos/$filename" &
          disown
        fi
      fi
    '';
  };
in {
  imports = [ ./noctalia.nix ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.packages = with pkgs; [
    fuzzel
    noctalia-shell
    niri-session-menu
    niri-screen-record
  ];
}
