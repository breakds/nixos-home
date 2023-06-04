{ lib, pkgs, ... }:

let sysConfig = (import <nixpkgs/nixos> {}).config;

in {
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "Break Yang";
    userEmail = lib.mkDefault "breakds@gmail.com";

    difftastic = {
      enable = true;
    };

    signing = {
      key = "breakds@gmail.com";
      # Disabled because otherwise it will ask me to type the password
      # for the GPG key every time. Maybe until I figure out the GPG
      # agent thing.
      signByDefault = false;
    };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "master";
      advice.addIgnoredFile = false;
    };
  };
}
