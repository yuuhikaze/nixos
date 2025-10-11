{ lib, authorizedKeys, ... }: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    timeout = 0; # hides boot menu, hold space during boot to bring menu up
  };
  # @source: https://www.brokenpip3.com/posts/2025-05-25-nixos-secure-installation-hetzner
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2224;
        authorizedKeys = with authorizedKeys; [ server desktop laptop ];
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
