{ pkgs, ... }: with pkgs; {
  systemPackages = [
    curl
    netcat-gnu
    ncdu
    neovim
    efibootmgr
  ];
  homePackages = [
    librewolf-bin
    kitty
    fastfetch
  ];
}
