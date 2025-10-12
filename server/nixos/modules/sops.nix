{
  sops = {
    defaultSopsFormat = "yaml";
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/persist/var/keys/sops-nix";
    # @source: https://github.com/Mic92/sops-nix/issues/427
    gnupg.sshKeyPaths = [ ];
    # @source: https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    secrets."system/users/root".neededForUsers = true;
  };
}
