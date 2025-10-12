let packageBundle = import ../../common/values/package-bundle.nix;
in with packageBundle;
{ pkgs, ... }: {
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "yuuhikaze";
      userEmail = "yuuhikaze@protonmail.com";
    };
  };
  home.packages = with pkgs;
    [
      uwsm
      mako
      swayosd
      rofi-wayland
      nemo
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
    ] ++ homePackages;
}
