{
  inputs = {
    # Use stable packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Define unstable packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      # Create an overlay to add unstable packages
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    in {
    nixosConfigurations = {
      # Server configuration (formerly server/flake.nix#generic)
      server = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = overlays; }
          ./server/nixos/configuration.nix
          inputs.impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-facter-modules.nixosModules.facter
        ];
        specialArgs = {
          authorizedKeys = import ./common/values/authorized-keys.nix;
          host = "server";
        };
      };

      # Desktop configuration (formerly desktop/flake.nix#generic)
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = overlays; }
          ./desktop/nixos/configuration.nix
          ./desktop/home-manager/home.nix
          inputs.impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-facter-modules.nixosModules.facter
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules =
              [ inputs.impermanence.nixosModules.home-manager.impermanence ];
          }
          inputs.stylix.nixosModules.stylix
        ];
        specialArgs = {
          authorizedKeys = import ./common/values/authorized-keys.nix;
          host = "desktop";
        };
      };
    };
  };
}
