{ lib, host, ... }: {
  imports = [
    ./audio.nix
    ./bootloader.nix
    (import ./facter.nix { inherit host; })
    ./garbage-collector.nix
    (import ./lanzaboote.nix { inherit lib host; })
    ./locale.nix
    ./networking.nix
    ./openssh.nix
    ./security.nix
    ./sysctl.nix
    ./tmpfiles.nix
  ];
}
