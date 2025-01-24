{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      pyright
      openssl.dev
      zlib
      pkg-config
    ]);
  };
}
