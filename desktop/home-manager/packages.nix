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
    swayosd
    fastfetch
    kitty
    nemo
    rofi-wayland
    mako
    uwsm
    librewolf-bin
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];
}
