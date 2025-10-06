{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
} @args:
{
  # IMPORTS
  imports = [
    # Enables non-free firmware
    (modulesPath + "/installer/scan/not-detected.nix")
    # Common conifiguration for QEMU VMs
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
  ];
  # BOOTLOADER
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
  };
  
  # TIME ZONE
  time.timeZone = "America/Guayaquil";
  # SOPS
  sops = {
    defaultSopsFormat = "yaml";
    defaultSopsFile = ./secrets/secrets.yaml;
    # @source: https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    age.keyFile = "/persist/var/lib/sops-nix/key.txt";
    secrets."system/users/root".neededForUsers = true;
  };
  # SERVICES
  services.openssh.enable = true;
  # PACKAGES
  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
  ];
  # DEPLOY KEY
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."system/users/root".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Cuipi+gnoQ78FmzWRr/Aco0cfRld3lJtRCmnISLrQ"
    ];
  };
  # IMPERMANENCE
  # @source: https://github.com/nix-community/disko/issues/192#issuecomment-2567944604
  # Ensure /persist is mounted before "user activation" script is run
  fileSystems."/persist".neededForBoot = true;
  # Ensure config is preserved for virtualized environments
  virtualisation.vmVariantWithDisko = {
    virtualisation.fileSystems."/persist".neededForBoot = true;
  };
  # @source: https://nixos.wiki/wiki/Impermanence
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/sops-nix/keys.txt"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    # users.user = {
    #   directories = [
    #     "Downloads"
    #     "Pictures"
    #     "Documents"
    #     "Videos"
    #     { directory = ".gnupg"; mode = "0700"; }
    #     { directory = ".ssh"; mode = "0700"; }
    #     { directory = ".local/share/keyrings"; mode = "0700"; }
    #   ];
    #   files = [
    #     ".screenrc"
    #   ];
    # };
  };
  # EXPERIMENTAL FEATURES
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
  # NIXOS VERSION
  system.stateVersion = "25.05";
}
