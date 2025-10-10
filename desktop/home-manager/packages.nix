{ pkgs, ... }: {
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "yuuhikaze";
      userEmail = "yuuhikaze@protonmail.com";
    };
  };
  home.packages = with pkgs; [
    fastfetch
    kitty
    nemo
    rofi-wayland
    librewolf-bin
    mako
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];
}
