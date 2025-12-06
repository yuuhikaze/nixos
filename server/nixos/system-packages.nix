let packageBundlePath = ../../common/values/package-bundle.nix;
in { pkgs, ... }:
let packageBundle = (import packageBundlePath { inherit pkgs; });
in with packageBundle; {
  environment.systemPackages = with pkgs; [ fail2ban ] ++ systemPackages ++ unstableSystemPackages;
  fonts.packages = with pkgs; [ terminus_font ];
}
