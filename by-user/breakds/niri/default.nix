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
in {
  imports = [ ./noctalia.nix ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.packages = with pkgs; [
    fuzzel
    noctalia-shell
    niri-session-menu
    tessen
  ];

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [key-bindings]
    # Tessen OTP support: custom-8 = exit code 17 (autotype OTP),
    # custom-9 = exit code 18 (copy OTP)
    custom-8=Control+o
    custom-9=Control+Shift+o
  '';
}
