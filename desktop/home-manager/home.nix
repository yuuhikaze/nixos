{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.user = {
      imports = [ ./packages.nix ./modules ];
      home.username = "user";
      home.homeDirectory = "/home/user";
      home.stateVersion = "25.05";
    };
  };
}
