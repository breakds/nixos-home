{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    # Partly designed by ChatGPT.
    colorSchemes = {
      BreakDrucula = {
        ansi = [
          "#000000" "#ff5555" "#50fa7b" "#f1fa8c"
          "#6272a4" "#bd93f9" "#8be9fd" "#f8f8f2"
        ];
        brights = [
          "#777777" "#D04A4A" "#46D56B" "#DDDC75"
          "#8294D1" "#AA82D6" "#9CF1F1" "#DEDBD7"
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
        font_size = ${if config.home.bds.laptopXsession then "13.0" else "12.0"},
        color_scheme = "BreakDrucula",
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        keys = {
          { key = '1', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '2', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '3', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '4', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '5', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '6', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '7', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '8', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '9', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment, },
          { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0), },
          { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1), },
          { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2), },
          { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3), },
          { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4), },
          { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab(5), },
          { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab(6), },
          { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab(7), },
          { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab(8), },
          { key = 'j', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1), },
          { key = ';', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1), },
        },
      }
    '';
  };
}
