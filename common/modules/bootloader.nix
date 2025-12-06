{ pkgs, lib, authorizedKeys, ... }:
let
  btrfsImpermanenceScript = pkgs.writeScriptBin "btrfs-impermanence"
    (builtins.readFile ../scripts/btrfs-impermanence.nu);
in {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    timeout = 0; # hides boot menu, hold space during boot to bring menu up
  };
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    systemd.storePaths = [ "${btrfsImpermanenceScript}" ];
    systemd.extraBin = {
      nu = "${pkgs.nushell}/bin/nu";
      mount = lib.mkForce "${pkgs.util-linux}/bin/mount";
      umount = lib.mkForce "${pkgs.util-linux}/bin/umount";
      btrfs = lib.mkForce "${pkgs.btrfs-progs}/bin/btrfs";
      mv = lib.mkForce "${pkgs.coreutils}/bin/mv";
      mkdir = lib.mkForce "${pkgs.coreutils}/bin/mkdir";
      ls = lib.mkForce "${pkgs.coreutils}/bin/ls";
      rm = lib.mkForce "${pkgs.coreutils}/bin/rm";
    };
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2224;
        authorizedKeys = with authorizedKeys; [ server desktop laptop ];
        hostKeys = [ "/persist/etc/secrets/initrd/ssh_host_ed25519_key" ];
      };
    };
    # @source: https://blog.decent.id/post/nixos-systemd-initrd/
    systemd.enable = true;
    systemd.services.btrfs-blank-root = {
      description =
        "Blanks root btrfs subvolume, archives three previous generations";
      wantedBy = [ "initrd.target" ];
      requires = [ "systemd-cryptsetup@crypted\\x2dnvme.service" ];
      after = [ "systemd-cryptsetup@crypted\\x2dnvme.service" "dev-mapper-crypted\\x2dnvme.device" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [ nushell btrfs-progs coreutils util-linux ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        /bin/env nu '${btrfsImpermanenceScript}/bin/btrfs-impermanence'
      '';
    };
  };
}
