# nixos-home
This is the flake of my home manager settings

## Syncthing

`by-user/breakds/syncthing.nix` owns the peer and folder settings. Hosts opt in
with `home-manager.users.breakds.services.syncthing.enable = true`; NixOS owns
the firewall rules and `users.users.breakds.linger = true`.

Both user services set `XDG_STATE_HOME` to `~/syncthing/.config`, preserving the
existing NixOS service's config, device keys, and database in place. The synced
folder remains `~/syncthing/workspace`.

For the first switch, stop the old system units before rebuilding:

```sh
sudo systemctl stop syncthing-init.service syncthing.service
sudo nixos-rebuild switch --flake .#HOST
systemctl --user status syncthing.service syncthing-init.service
```

Verify that the device ID and peer connections match the old service. To roll
back, stop both user units before switching to the previous NixOS generation;
both generations use the same state directory.

## TODO

1. `sway` has an issue where the curosr size is very small on GTK-based applications such as emacs and chrome.
