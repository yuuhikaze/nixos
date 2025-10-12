{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    # X compatibility layer
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    # Fix cursor jittering
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint Electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  hardware = {
    # OpenGL
    graphics.enable = true;
    # Needed for Nvidia systems
    nvidia.modesetting.enable = true;
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
  security.pam.services.hyprlock = { };
}
