{ lib, pkgs, ... }:

{
  programs.git = {
    includes = [
      {
        condition = "gitdir:~/projects/psynk.ai/";
        contents = {
          gpg.format = "ssh";
          user = {
            name = "Break Yang";
            email = "breakds@psynk.ai";
            signingKey = "~/.ssh/breakds_psynk";
          };
          core.sshCommand = "SSH_AUTH_SOCK= ssh -i ~/.ssh/breakds_psynk -o IdentitiesOnly=yes -o ControlMaster=no -S none";
        };
      }
    ];
  };
}
