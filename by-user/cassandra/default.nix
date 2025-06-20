{ pkgs,  ... }:

{
  imports = [
    ./git.nix
  ];

  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
  };

  home.packages = with pkgs; [
    graphviz
    graphicsmagick
    ffmpeg
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };
  
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };
}
