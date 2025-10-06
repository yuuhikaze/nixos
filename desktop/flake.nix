{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      nixpkgs,
      impermanence,
      sops-nix,
      disko,
      ...
    }: {
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
        ];
      };
    };
}
