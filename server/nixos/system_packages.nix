{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ncdu
    curl
    neovim
    libnotify
    efibootmgr
    easytier
  ];
  fonts.packages = with pkgs; [
    terminus_font
  ];
}
