{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./wezterm.nix
  ];

  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
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

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 50%" "--border" ];
  };
}
