{ pkgs, ... }: {
  systemd.services."easytier" = {
    enable = true;
    script =
      "easytier-core -d --network-name sumeragi --network-secret changeme -p tcp://public.easytier.cn:11010 --dev-name et0 --multi-thread";
    serviceConfig = {
      Restart = "always";
      RestartMaxDelaySec = "1m";
      RestartSec = "100ms";
      RestartSteps = 9;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = with pkgs; [ easytier iproute2 bash ];
  };
}
