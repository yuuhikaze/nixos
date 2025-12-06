{ host }: {
  networking = {
    hostName = host;
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
    firewall = {
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
  };
}
