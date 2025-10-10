{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.user = {
      imports = [ ./packages.nix ./modules ];
      home.username = "user";
      home.homeDirectory = "/home/user";
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        settings = { };
      };
      home.stateVersion = "25.05";
    };
  };
}
