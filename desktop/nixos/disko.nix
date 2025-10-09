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
                  "umask=0077"
                ];
              };
            };
            swap = {
              size = "6G";
              content = {
                type = "swap";
                discardPolicy = "both"; # free unused blocks (not supported for HDDs)
                randomEncryption = true;
                priority = 100; # encrypt as long as there is space for it
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-nvme";
                passwordFile = LUKSPasswordFile;
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = crypttabExtraOpts;
                content = {
                  type = "btrfs";
                  extraArgs = btrfsExtraArgs;
                  subvolumes =
                    let
                      btrfsMountOptions = [
                        "compress=zstd:1" # Use zstd with fastest compression level
                        "noatime"         # Don't update access time metadata on files
                        "space_cache=v2"  # Cache free blocks
                        "ssd"             # Explicit SSD optimization
                      ];
                    in
                    {
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
                        "autodefrag"      # Improves write speed on HDDs (harmful for SDDs)
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
