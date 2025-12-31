{ config, lib, ... }: {
  services.minecraft-server = {
    enable = true;

    # Accept the Minecraft EULA
    eula = true;

    # Use declarative configuration
    declarative = true;

    # Data directory (default: /var/lib/minecraft)
    dataDir = "/var/lib/minecraft";

    # Don't open firewall externally - HAProxy will handle external access
    # Internal access on LAN will be allowed below
    openFirewall = false;

    # Server properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      difficulty = "normal";
      max-players = 20;
      motd = "NixOS Minecraft Server - yuuhikaze.com";
      white-list = true;
      enable-command-block = false;
      spawn-protection = 16;
      max-world-size = 29999984;
      view-distance = 10;
      simulation-distance = 10;
      online-mode = true;
    };

    # Whitelist players (username = UUID)
    # Get UUIDs from https://mcuuid.net/
    whitelist = {
      # Example:
      # "playerName" = "uuid-here";
    };

    # JVM options for performance
    jvmOpts = "-Xmx2048M -Xms2048M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200";
  };

  # Allow internal network access to Minecraft
  networking.firewall.allowedTCPPorts = [ 25565 ];

  # Persist Minecraft data across reboots (if using impermanence)
  environment.persistence."/persist" = lib.mkIf config.environment.persistence."/persist".enable {
    directories = [
      "/var/lib/minecraft"
    ];
  };
}
