# @source: https://wiki.nixos.org/wiki/Incus
{
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    interfaces.incusbr0.allowedTCPPorts = [
      53 # Incus DNS
      67 # Incus DHCPv4
    ];
    interfaces.incusbr0.allowedUDPPorts = [
      53 # Incus DNS
      67 # Incus DHCPv4
    ];
    allowedTCPPorts = [
      # EasyTier
      11010
      11011
      11012
    ];
    allowedUDPPorts = [
      # EasyTier
      11010
      11011
      11012
    ];
  };
}
