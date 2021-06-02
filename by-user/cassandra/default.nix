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
}
