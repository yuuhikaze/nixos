{ config, pkgs, ... }: {
  sops.secrets."system/easytier/network-secret" = {
    restartUnits = [ "easytier.service" ];
  };

  # instances: https://easytier.gd.nkbpal.cn/status/easytier
  systemd.services."easytier" = {
    enable = true;
    script = ''
      easytier-core -d --network-name sumeragi -n 192.168.100.0/24 \
        -p tcp://8.138.6.53:11010 -p tcp://et.sh.suhoan.cn:11010 \
        --dev-name et0 --multi-thread --proxy-forward-by-system
    '';
    serviceConfig = {
      EnvironmentFile = config.sops.secrets."system/easytier/network-secret".path;
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
