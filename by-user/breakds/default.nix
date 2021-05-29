{ pkgs,  ... }:

{
  imports = [
    ./git.nix
    ./xsession.nix
    ./alacritty.nix
  ];
  
  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".zshrc".source = ./dotfiles/zshrc;
  };
}
