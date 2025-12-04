{
  boot.kernel.sysctl = {
    # Detect MTU automatically
    # Prevents flakiness due to incorrect MTU assumptions
    "net.ipv4.tcp_mtu_probing" = 1;
    # Enable packet forwarding
    "net.ipv4.conf.all.forwarding" = true;
  };
}
