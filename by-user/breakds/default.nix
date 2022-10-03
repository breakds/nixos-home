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

  programs.zsh = {
    enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "pass"     # pass store auto-completion
        "dotenv"
        "extract"  # decompression general command
        "z"
        "nix-zsh-completions"
        "nix-shell"
      ];
    };

    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gst = "git status";
    };
  };
}
