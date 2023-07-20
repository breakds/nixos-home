{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      return {
        font = wezterm.font("Fira Code"),
        font_size = ${if config.home.bds.laptopXsession then "8.0" else "10.0"},
        color_scheme = "DanQing (base16)",
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
      }
    '';
  };
}
