{ config, ... }: {
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."system/users/root".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Cuipi+gnoQ78FmzWRr/Aco0cfRld3lJtRCmnISLrQ"
    ];
  };
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    hashedPasswordFile = config.sops.secrets."system/users/user".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Cuipi+gnoQ78FmzWRr/Aco0cfRld3lJtRCmnISLrQ"
    ];
  };
}
