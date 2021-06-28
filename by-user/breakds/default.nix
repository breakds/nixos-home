{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./xsession.nix
    ./alacritty.nix
    ./sync.nix
  ];
  
  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".zshrc".source = ./dotfiles/zshrc;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };
}
