{ pkgs, ... }:

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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
