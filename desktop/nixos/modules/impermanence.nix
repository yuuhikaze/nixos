{
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
}
