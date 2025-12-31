{
  imports = [
    ../../../common/modules
    ./bootloader.nix
    ./dns.nix
    ./easytier.nix
    ./fail2ban.nix
    # ./haproxy.nix
    ./impermanence.nix
    # ./minecraft.nix
    ./networking.nix
    ./sops.nix
    ./users.nix
    ./virtualisation.nix
  ];
}
