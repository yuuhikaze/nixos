{
  systemd.tmpfiles = {
    rules = [
      # Journaling performs heavy writes
      # Disable Btrfs CoW to improve performance (no gazillion copies are made)
      # A warning on first boot is expected since journal directory is created BEFORE tmpfiles runs
      "h /var/log/journal - - - - +C"
    ];
  };
}
