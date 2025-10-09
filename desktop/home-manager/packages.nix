{ pkgs, ... }: {
  home.packages = with pkgs; [
    nushell
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
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "yuuhikaze";
      userEmail = "yuuhikaze@protonmail.com";
    };
  };
}
