let impermanencePresets = import ../../../common/values/impermanence-presets.nix;
in with impermanencePresets; {
  fileSystems."/persist".neededForBoot = true;
  # @source: https://nixos.wiki/wiki/Impermanence
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [ ] ++ systemDirectories;
    files = [ ] ++ systemFiles;
  };
}
