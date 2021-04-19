{ config, lib, pkgs, ... }:

let stable-nodejs = pkgs.nodejs-12_x;

    # nodejs-lst = buildNodejs {
    #   enableNpm = true;
    #   version = "12.18.2";
    #   sha256 = "1xmy73q3qjmy68glqxmfrk6baqk655py0cic22h1h0v7rx0iaax8";
    # };


in {
  home.packages = with pkgs; [
    stable-nodejs
    (yarn.override { nodejs = stable-nodejs; })
    (nodePackages.create-react-app.override { nodejs = stable-nodejs; })
  ];
}
