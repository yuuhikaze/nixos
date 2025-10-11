{
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay";
    extraOptions = "--iptables=False";
  };
}
