{
  systemDirectories = [
    "/var/log"
    "/var/lib/bluetooth"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
    "/etc/NetworkManager/system-connections"
    "/var/lib/sbctl"
    "/etc/secrets/initrd"
    "/etc/secureboot"
  ];
  systemFiles = [
    "/etc/machine-id"
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
    {
      file = "/var/keys/sops-nix";
      parentDirectory.mode = "0700";
    }
  ];
  homeDirectories = [ ];
  homeFiles = [ ];
}
