# @extends: common/modules/networking.nix
# @source: https://wiki.nixos.org/wiki/Incus
{
  networking = {
    firewall = {
      interfaces.incusbr0.allowedTCPPorts = [
        53 # Incus DNS
        67 # Incus DHCPv4
      ];
      interfaces.incusbr0.allowedUDPPorts = [
        53 # Incus DNS
        67 # Incus DHCPv4
      ];
      # Trust EasyTier interface to forward traffic
      trustedInterfaces = [ "et0" ];
    };
    nat = {
      # Enable NAT/masquerading for EasyTier interface
      enable = true;
      # Interface where traffic originates from
      internalInterfaces = [ "et0" ];
      # Interface where traffic exits to
      externalInterface = "enp3s0";
    };
  };
}
