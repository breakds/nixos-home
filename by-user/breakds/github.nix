{ lib, pkgs, ... }:

{
  programs.gh = {
    enable = true;
    settings = {
      editor = "emacs";
      git_protocol = "ssh";
    };
  };

  programs.gh-dash.enable = true;
}
