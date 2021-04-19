{ pkgs,  ... }:

{
  imports = [
    ./git.nix
    ./js-dev.nix
  ];
  
  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
  };

  home.packages = with pkgs; [
    graphviz
    graphicsmagick
    ffmpeg
  ];
}
