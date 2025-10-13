let packageBundlePath = ../../common/values/package-bundle.nix;
in { pkgs, ... }:
let packageBundle = (import packageBundlePath { inherit pkgs; });
in with packageBundle; {
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
