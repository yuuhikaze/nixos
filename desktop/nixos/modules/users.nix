{ config, authorizedKeys, ... }: {
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."system/users/root".path;
    openssh.authorizedKeys.keys = with authorizedKeys; [ server desktop laptop ];
  };
  users.users.user = {
    home = "/home/user";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    hashedPasswordFile = config.sops.secrets."system/users/user".path;
    openssh.authorizedKeys.keys = with authorizedKeys; [ server desktop laptop ];
  };
}
