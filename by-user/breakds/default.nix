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
      ];
    };

    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      
      {
        # will source nix-zsh-completions.plugin.zsh
        name = "nix-zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "spwhitt";
          repo = "nix-zsh-completions";
          rev = "0.4.4";
          sha256 = "sha256-Djs1oOnzeVAUMrZObNLZ8/5zD7DjW3YK42SWpD2FPNk=";
        };
      }

      {
        # will source nix-shell.plugin.zsh
        name = "nix-sehll";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "sha256-IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
        };
      }
    ];

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
