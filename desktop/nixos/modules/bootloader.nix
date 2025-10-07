{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
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
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Cuipi+gnoQ78FmzWRr/Aco0cfRld3lJtRCmnISLrQ"
        ];
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        shell = "/bin/cryptsetup-askpass";
      };
    };
  };
}
