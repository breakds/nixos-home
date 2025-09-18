{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./github.nix
    ./wezterm.nix
    ./xsession
    ./sync.nix
    ./ssh.nix
    ./unison-remote-dev.nix
    ./vscode.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    (pkgs.callPackage ../../pkgs/resurrect {})
    mcomix
  ];

  home.file = {
    ".inputrc".source = ./dotfiles/inputrc;
    ".gdbinit".text = ''
      set auto-load safe-path /nix/store
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    daemon.enable = false;  # Might need in the future.
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.breakds.org";
      sync_frequency = "5m";
      update_check = false;
      style = "full";
      sync.records = true;
      dotfiles.enabled = true;
    };
  };

  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "emacs";
    };

    bashrcExtra = ''
      ${pkgs.fastfetch}/bin/fastfetch
    '';
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
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

    initContent = ''
      export VISUAL='emacs'
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='emacs'
      else
        export EDITOR='emacs'
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

  gtk = {
    enable = true;
    gtk2.extraConfig = ''
       gtk-recent-files-max-age = 0
    '';
    gtk3.extraConfig = {
      gtk-recent-files-max-age = 0;
      gtk-recent-files-limit = 0;
    };
    gtk4.extraConfig = {
      gtk-recent-files-max-age = 0;
      gtk-recent-files-limit = 0;
    };
  };
}
