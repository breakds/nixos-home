{ lib, pkgs, ... }:

let sysConfig = (import <nixpkgs/nixos> {}).config;

in {
  programs.git = {
    enable = true;
    package = lib.mkDefault pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "Break Yang";
    userEmail = lib.mkDefault "breakds@gmail.com";
    signing = {
      key = "breakds@gmail.com";
      signByDefault = false;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
