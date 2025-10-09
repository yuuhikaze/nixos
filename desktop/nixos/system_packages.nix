{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ncdu
    curl
    neovim
    libnotify
  ];
}
