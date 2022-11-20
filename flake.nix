{
  description = "A bunch of home-manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    mkHomeManagerModule = { user, imports }: { config, ... }: {
      imports = [
        (home-manager.nixosModules.home-manager)
      ];
      home-manager = {
        # This is needed to make sure that home-manager follows the
        # pkgs/nixpkgs specified in this flake.
        #
        # Relevant github issue: https://github.com/divnix/devos/issues/30
        useGlobalPkgs = true;
        useUserPackages = true;
      };
      home-manager.users."${user}" = {
        inherit imports;
      };

    }; in {
      nixosModules.breakds-home = mkHomeManagerModule {
        user = "breakds";
        imports = [ ./by-user/breakds ];
      };
      
      nixosModules.cassandra-home = mkHomeManagerModule {
        user = "cassandra";
        imports = [ ./by-user/cassandra ];
      };
      
      nixosConfigurations.breakds-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/breakds-vm.nix
          self.nixosModules.breakds-home
        ];
      };
      
      nixosConfigurations.cassandra-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/cassandra-vm.nix
          self.nixosModules.cassandra-home
        ];
      };
    };
}
