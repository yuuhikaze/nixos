let
  btrfsExtraArgs = [
    "-f"
    "--csum xxhash"
  ];
  crypttabExtraOpts = [
    "tpm2-device=auto"
    "tpm2-measure-pcr=yes"
  ];
  LUKSPasswordFile = "/tmp/pass";
  LUKSAdditionalKeyFiles = [ "/tmp/CRYPT/desktop_key" ];
in
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = [
                  "defaults"
                  "noexec"
                  "nosuid"
                  "nodev"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = LUKSPasswordFile;
                additionalKeyFiles = LUKSAdditionalKeyFiles;
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = crypttabExtraOpts;
                content = {
                  type = "btrfs";
                  extraArgs = btrfsExtraArgs;
                  subvolumes =
                    let
                      btrfsMountOptions = [
                        "compress=zstd:1" # Use zstd with fastest compression level
                        "noatime"         # Don't update access time reading files
                        "space_cache=v2"  # Caches free blocks
                        "ssd"             # Explicit SSD optimization
                      ];
                    in
                    {
                      "/swap" = {
                        mountpoint = "/swap";
                        swap.swapfile.size = "6G";
                      };
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = btrfsMountOptions;
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = btrfsMountOptions;
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = btrfsMountOptions;
                      };
                    };
                };
              };
            };
          };
        };
      };
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-sda";
                passwordFile = LUKSPasswordFile;
                additionalKeyFiles = LUKSAdditionalKeyFiles;
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = crypttabExtraOpts;
                content = {
                  type = "btrfs";
                  extraArgs = btrfsExtraArgs;
                  subvolumes =
                    let
                      btrfsMountOptions = [
                        "compress=zstd:1" # Use zstd with fastest compression level
                        "noatime"         # Don't update access time reading files
                        "space_cache=v2"  # Caches free blocks
                        "autodefrag"      # Auto-defragment files on write to reduce long-term fragmentation
                      ];
                    in
                    {
                      "/atlas" = {
                        mountpoint = "/mnt/atlas";
                        mountOptions = btrfsMountOptions;
                      };
                      "/hermes" = {
                        mountpoint = "/mnt/hermes";
                        mountOptions = btrfsMountOptions;
                      };
                      "/hades" = {
                        mountpoint = "/mnt/hades";
                        mountOptions = btrfsMountOptions;
                      };
                    };
                };
              };
            };
          };
        };
      };
    };
  };
}
