{
  fileSystems."/persist".neededForBoot = true;
  # @source: https://nixos.wiki/wiki/Impermanence
  programs.fuse.userAllowOther = true;
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/sbctl"
    ];
    files = [
      "/etc/machine-id"
      "/etc/secrets/initrd/ssh_host_ed25519_key"
      "/etc/secrets/initrd/ssh_host_ed25519_key.pub"
      {
        file = "/var/keys/sops-nix";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
