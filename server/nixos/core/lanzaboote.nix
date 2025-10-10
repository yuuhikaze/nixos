{ lib, ... }:
let
  # Check if marker file exists
  lanzabooteEnabled = builtins.pathExists ../../lanzaboote-enabled;
in {
  boot.loader.systemd-boot.enable = lib.mkForce (!lanzabooteEnabled);
  boot.lanzaboote = {
    enable = lanzabooteEnabled;
    pkiBundle = "/var/lib/sbctl";
  };
}
