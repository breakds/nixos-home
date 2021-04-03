{ pkgs,  ... }:

{
  imports = [
    ./git.nix
  ];
  
  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".zshrc".source = ./dotfiles/zshrc;
  };
}
