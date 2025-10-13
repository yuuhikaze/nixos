{
  systemd.tmpfiles = {
    rules = [
      # Journaling performs heavy writes
      # Disable Btrfs CoW to improve performance (no gazillion copies are made)
      "h /var/log/journal - - - - +C"
    ];
  };
}
