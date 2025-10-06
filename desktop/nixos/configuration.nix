{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
} @args:
{
  imports = [
    # Enables non-free firmware
    (modulesPath + "/installer/scan/not-detected.nix")
    # Common conifiguration for QEMU VMs
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./modules
  ];
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
