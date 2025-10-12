let packageBundle = import ../../common/values/package-bundle.nix;
in with packageBundle;
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ easytier ] ++ systemPackages;
  fonts.packages = with pkgs; [ terminus_font ];
}
