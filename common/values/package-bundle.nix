{ pkgs, ... }: with pkgs; {
  systemPackages = [
    nushell
    curl
    netcat-gnu
    ncdu
    neovim
    efibootmgr
    findutils.locate
    fd
    # tpm2-tss
    sbctl
    tree
  ];
  homePackages = [
    librewolf-bin
    kitty
    fastfetch
  ];
}
