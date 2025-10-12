{ lib, host, ... }:
let
  # Check if marker file exists
  lanzabootePath = toString ./. + "/../../${host}/lanzaboote-enabled";
  lanzabooteEnabled = builtins.pathExists lanzabootePath;
in {
  boot.loader.systemd-boot.enable = lib.mkForce (!lanzabooteEnabled);
  boot.lanzaboote = {
    enable = lanzabooteEnabled;
    pkiBundle = "/var/lib/sbctl";
  };
}
