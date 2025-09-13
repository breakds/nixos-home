{ lib, pkgs, ... }:

let sysConfig = (import <nixpkgs/nixos> {}).config;

in {
  imports = [ ./git-psynk.nix ];
  
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "Break Yang";
    userEmail = lib.mkDefault "breakds@gmail.com";

    difftastic = {
      enable = true;
    };

    signing = {
      format = "ssh";
      key = "~/.ssh/breakds_samaritan";
      signByDefault = true;
    };

    ignores = [
      "*~"
      ".direnv"
      ".envrc"
      ".goose"
      ".aider*"
      "result"
    ];

    # https://blog.gitbutler.com/how-git-core-devs-configure-git/
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "master";
      advice.addIgnoredFile = false;
      http.version = "HTTP/1.1";
      core.excludesFile = "~/.config/git/global.gitignore";

      # `git branch` will list branches in multi columns
      column.ui = "auto";
      # `git branch` will rank branches by most-recent-edits
      branch.sort = "-committerdate";
      # A better algorithm when computing diff and whatsoever.
      diff.algorithm = "histogram";

      push.autoSetupRemote = true;   # No more git push -u
      push.followTags = true;        # Push also upload all tags

      # Sane fetch behaviors
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      # Fix my fingers please
      help.autocorrect = "prompt";

      # When rebase a lot of commits, if a commit repeats itself on every
      # update, auto resolve.
      rerere.enable = true;
      rerere.autoupdate = true;

      log.date = "iso";  # YYYY-MM-DD is much more readable

      apply.whitespace = "fix";  # Please remove trailing whitespaces
    };

    aliases = {
      # Copied from Kiran Rao: https://kiranrao.ca/2024/06/21/git-config.html
      logall = "log --graph --abbrev-commit --decorate --date=short --format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' --branches --remotes --tags";
    };
  };

  home.file = {
    ".config/git/global.gitignore".source = ./dotfiles/gitignore;
  };
}
