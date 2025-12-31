{ config, lib, ... }:
let
  # Define your local network subnet
  localNetwork = "192.168.100.0/24";

  # Internal DNS zones (not visible externally)
  # Add your internal hosts here
  internalHosts = [
    "router.home.arpa. IN A 192.168.100.1"   # OpenWrt router
    "server.home.arpa. IN A 192.168.100.2"   # NixOS server (this machine)
    "nas.home.arpa. IN A 192.168.100.10"     # Example: NAS
    "printer.home.arpa. IN A 192.168.100.20" # Example: Printer
    # Add more internal hosts as needed
  ];
in
{
  services.unbound = {
    enable = true;

    settings = {
      server = {
        # Listen on all interfaces
        interface = [ "0.0.0.0" ];
        port = 53;

        # Access control - allow queries from local networks
        access-control = [
          "127.0.0.0/8 allow"
          "${localNetwork} allow"
          "0.0.0.0/0 refuse"  # Refuse all others
        ];

        # Security hardening
        hide-identity = true;
        hide-version = true;
        harden-glue = true;
        harden-dnssec-stripped = true;
        harden-below-nxdomain = true;
        harden-referral-path = true;
        use-caps-for-id = false;

        # Performance tuning
        prefetch = true;
        prefetch-key = true;
        cache-min-ttl = 300;
        cache-max-ttl = 86400;

        # Privacy
        qname-minimisation = true;
        aggressive-nsec = true;

        # Buffer size (recommended for DNSSEC)
        edns-buffer-size = 1232;

        # Local zones (internal DNS - split-horizon)
        local-zone = [
          "home.arpa. static"
        ];

        # Internal host records
        local-data = internalHosts;

        # Serve local addresses from reverse lookup
        private-address = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "169.254.0.0/16"
          "fd00::/8"
          "fe80::/10"
        ];
      };

      # Forward all external queries to Quad9 with DNS-over-TLS
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
          ];
          forward-tls-upstream = true;
        }
      ];
    };
  };

  # Open DNS ports in firewall
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  # Persist Unbound data across reboots (if using impermanence)
  environment.persistence."/persist" = lib.mkIf config.environment.persistence."/persist".enable {
    directories = [
      "/var/lib/unbound"
    ];
  };
}
