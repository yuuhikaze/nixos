{
  sops = {
    defaultSopsFormat = "yaml";
    defaultSopsFile = ../../secrets/secrets.yaml;
    # @source: https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    age.keyFile = "/persist/var/lib/sops-nix/key.txt";
    secrets."system/users/root".neededForUsers = true;
  };
}
