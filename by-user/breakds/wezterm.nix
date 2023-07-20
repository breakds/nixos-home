{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = ${if config.home.bds.laptopXsession then "8.0" else "10.0"},
        color_scheme = "Tomorrow Night",
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
