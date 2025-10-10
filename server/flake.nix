{
  inputs = {
    # Use stable packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      # Ensures this flake uses the same nixpkgs as the main system
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url =
      "github:nix-community/impermanence"; # does not have override for inputs
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./nixos/core
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixos-facter-modules.nixosModules.facter
      ];
      specialArgs = { authorizedKeys = import ../common/authorized-keys.nix; };
    };
  };
}
