{ lib, ... }: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    timeout = 0; # hides boot menu, hold space during boot to bring it up
  };
  # @source: https://www.brokenpip3.com/posts/2025-05-25-nixos-secure-installation-hetzner
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    # CRITICAL: Copy the SSH host key INTO initrd at build time
    # Use mkForce to override NixOS's automatic setup (/etc/ssh/*)
    # secrets."/etc/secrets/initrd/ssh_host_ed25519_key" =
    #   lib.mkForce "/persist/etc/secrets/initrd/ssh_host_ed25519_key";
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2224;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Cuipi+gnoQ78FmzWRr/Aco0cfRld3lJtRCmnISLrQ"
        ];
        hostKeys = [ "/persist/etc/secrets/initrd/ssh_host_ed25519_key" ];
        shell = "/bin/cryptsetup-askpass";
      };
    };
    postDeviceCommands = lib.mkAfter ''
      mkdir -p /btrfs_tmp
      # Mount the unlocked Btrfs volume
      mount -o subvol=/ /dev/mapper/crypted-nvme /btrfs_tmp
      # Create a fresh root subvolume
      btrfs subvolume delete /btrfs_tmp/root
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };
}
