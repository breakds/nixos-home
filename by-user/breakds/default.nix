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
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (ps: with ps; [ zlib ]);
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };
}
