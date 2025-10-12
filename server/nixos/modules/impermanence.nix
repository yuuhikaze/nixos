{
  fileSystems."/persist".neededForBoot = true;
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
      "/var/lib/sbctl"
      "/etc/secrets/initrd"
      # "/etc/ssh" # with this turned on, SSH daemon will fail (will research further)
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/sops-nix";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
