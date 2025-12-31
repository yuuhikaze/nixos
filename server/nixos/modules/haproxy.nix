{ config, lib, ... }: {
  services.haproxy = {
    enable = true;
    config = builtins.readFile ../configs/haproxy.cfg;
  };

  # Open port 443 for external traffic
  networking.firewall.allowedTCPPorts = [
    443    # HAProxy SSL router
    8404   # HAProxy stats (optional, can be removed or firewalled)
  ];

  # Persist HAProxy state (if using impermanence)
  environment.persistence."/persist" = lib.mkIf config.environment.persistence."/persist".enable {
    directories = [
      "/var/lib/haproxy"
    ];
  };
}
