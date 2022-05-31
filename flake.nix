{
  description = "A bunch of home-manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    nixpkgs-2105.url = "github:NixOS/nixpkgs/nixos-21.05";    
    home-manager-2105.url = "github:nix-community/home-manager/release-21.05";
    home-manager-2105.inputs.nixpkgs.follows = "nixpkgs-2105";
  };

  outputs = { self, nixpkgs, nixpkgs-2105, home-manager, home-manager-2105, ... }: let
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

    };

    mkHomeManagerModule2105 = { user, imports }: { config, ... }: {
      imports = [
        (home-manager-2105.nixosModules.home-manager)
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
      
      nixosModules.breakds-home-laptop = mkHomeManagerModule {
        user = "breakds";
        imports = [
          ./by-user/breakds
          ./by-user/breakds/laptop.nix
        ];
      };
      
      nixosModules.cassandra-home = mkHomeManagerModule2105 {
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
      
      nixosConfigurations.breakds-laptop-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/breakds-vm.nix
          self.nixosModules.breakds-home-laptop
        ];
      };
      
      nixosConfigurations.cassandra-vm = nixpkgs-2105.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/cassandra-vm.nix
          self.nixosModules.cassandra-home
        ];
      };
    };
}
