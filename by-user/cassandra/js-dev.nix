{ config, lib, pkgs, ... }:

let pkgs = import <nixpkgs> {};

    # nodejs-lst = buildNodejs {
    #   enableNpm = true;
    #   version = "12.18.2";
    #   sha256 = "1xmy73q3qjmy68glqxmfrk6baqk655py0cic22h1h0v7rx0iaax8";
    # };

    nodejs-lst = pkgs.nodejs-12_x;

in {
  home.packages = with pkgs; [
    nodejs-lst
    (yarn.override { nodejs = nodejs-lst; })
    nodePackages.create-react-app
  ];
}
