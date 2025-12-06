{ pkgs, ... }: {
  systemPackages = with pkgs; [
    pciutils
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
  unstableSystemPackages = with pkgs.unstable;
    [
      easytier # allows specifying `network-secret` via an environment variable
    ];
  homePackages = with pkgs; [ librewolf-bin kitty fastfetch ];
}
