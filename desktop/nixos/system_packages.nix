{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ncdu
    curl
    neovim
    libnotify
    efibootmgr
  ];
  fonts.packages = with pkgs; [
    terminus_font
  ];
}
