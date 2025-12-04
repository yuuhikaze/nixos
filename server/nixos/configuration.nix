# `pkgs`, `lib`, `config` are automatically injected in all modules
# @source: https://nixos.org/manual/nixos/stable/options
{ modulesPath, ... }: {
  imports = [
    # Enables non-free firmware
    (modulesPath + "/installer/scan/not-detected.nix")
    # Common configuration for QEMU VMs
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./modules
    ./system-packages.nix
  ];
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  system.stateVersion = "25.05";
}
