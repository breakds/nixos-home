{ pkgs, ... }:

{
  programs.alacritty= {
    enable = true;
    
    settings = let
      draculaColorTheme = {
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0x6272a4";
          magenta = "0xbd93f9";
          cyan = "0x8be9fd";
          white = "0xf8f8f2";
        };
      };

      plainColorTheme = {
        primary = {
          background = "0x434343";
          foreground = "0xececec";
        };
        normal = {
          black = "0x000000";
          red = "0xc62828";
          green = "0x558b2f";
          yellow = "0xf9a825";
          blue = "0x1565c0";
          magenta = "0x6a1e9a";
          cyan = "0x00838f";
          white = "0xf2f2f2";
        };
      }; in {
        window.decorations = "full";
        scrolling.history = 10000;
        font = {
          normal.family = "Fira Code";
          bold.family = "Fira Code";
          italic.family = "Fira Code";
          size = 10.0;
          offset = { x = 0; y = 0; };
        };
        draw_bold_text_with_bright_colors = true;
        colors = draculaColorTheme;
      };
  };
}
