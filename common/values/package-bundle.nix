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
  unstableSystemPackages = with pkgs.unstable; [
    easytier
  ];
   /* error: attribute 'unstable' missing
   at /nix/store/vjjm2vl0fiqnbi1z5pszsizdz8wwxfrk-source/common/values/package-bundle.nix:16:33:
       15|   ];
       16|   unstableSystemPackages = with pkgs.unstable; [
         |                                 ^
       17|     easytier */
  homePackages = with pkgs; [
    librewolf-bin
    kitty
    fastfetch
  ];
}
