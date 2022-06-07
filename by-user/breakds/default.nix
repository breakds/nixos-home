{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./xsession.nix
    ./alacritty.nix
    ./sync.nix
    ./ssh.nix
  ];
  
  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".zshrc".source = ./dotfiles/zshrc;
    ".inputrc".source = ./dotfiles/inputrc;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };
}
