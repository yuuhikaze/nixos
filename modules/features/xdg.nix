{ pkgs, ... }: {
  home-manager = {
    users.user = {
      xdg.mimeApps.enable = true;
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
