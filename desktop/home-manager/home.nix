{
  imports = [
    ./packages.nix
    ./modules
  ];
  # User information
  home.username = "user";
  home.homeDirectory = "/home/user";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Home Manager version
  home.stateVersion = "25.05";
}
