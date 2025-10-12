{
  home.persistence."/persist/home/user" = {
    directories = [
      "Downloads"
      "Pictures"
      "Documents"
      "Videos"
      ".local/share/keyrings"
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
    # @source: https://github.com/nix-community/impermanence?tab=readme-ov-file#home-manager
    allowOther = true;
  };
}
