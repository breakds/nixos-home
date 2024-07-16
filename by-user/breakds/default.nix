{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./wezterm.nix
    ./xsession
    ./sync.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    (pkgs.callPackage ../../pkgs/resurrect {})
  ];

  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".inputrc".source = ./dotfiles/inputrc;
    ".gdbinit".text = ''
      set auto-load safe-path /nix/store
    '';
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
    ];

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gst = "git status";
    };

    initExtra = ''
      export VISUAL='emacs'
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='emacs'
      else
        export EDITOR='emacs'
      fi

      # Setting up direnv. Actually I am not entirely sure this is needed now.
      if [ -x "$(command -v direnv)" ]; then
        eval "$(direnv hook zsh)"
      fi

      # I do not like accepting autosuggestions with right arrow (i.e.
      # forward-char). Only keep end-of-line here.

      ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
        end-of-line
      )

      # Be fancy!
      ${pkgs.fastfetch}/bin/fastfetch
    '';
  };
}
