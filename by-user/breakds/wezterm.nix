{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    colorSchemes = {
      BreakDrucula = {
        ansi = [
          "#000000" "#ff5555" "#50fa7b" "#f1fa8c"
          "#6272a4" "#bd93f9" "#8be9fd" "#f8f8f2"
        ];
        brights = [
          "#444444" "#FF7575" "#6CFF97" "#FFFF00"
          "#7485C6" "#D9A6FF" "#A6FAFF" "#FCFCFC"
        ];
        background = "#282A36";
        cursor_bg = "#BEAF8A";
        cursor_border = "#BEAF8A";
        cursor_fg = "#1B1B1B";
        foreground = "#F8F8F2";
        selection_bg = "#444444";
        selection_fg = "#E9E9E9";
      };      
    };

    extraConfig = ''
      return {
        font = wezterm.font("Fira Code"),
        font_size = ${if config.home.bds.laptopXsession then "10.0" else "12.0"},
        color_scheme = "BreakDrucula",
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
      }
    '';
  };
}
