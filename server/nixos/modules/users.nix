{ config, authorizedKeys, ... }: {
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."system/users/root".path;
    openssh.authorizedKeys.keys = with authorizedKeys; [ server desktop laptop ];
  };
}
