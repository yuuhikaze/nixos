{
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2224;
        authorizedKeys = [
          "ssh-rsa <your-ssh-public-key>"
        ];
        hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
        shell = "/bin/cryptsetup-askpass";
      };
    };
  };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
  };
}
