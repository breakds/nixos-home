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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhsWithPackages (ps: with ps; [ zlib ]);
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };
}
