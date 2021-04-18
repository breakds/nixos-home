{ lib, pkgs, ... }:

let sysConfig = (import <nixpkgs/nixos> {}).config;

in {
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "Shan Qi";
    userEmail = lib.mkDefault "cassandraqs@gmail.com";
    signing = {
      key = "cassandraqs@gmail.com";
      signByDefault = false;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
