let filesystemOptions = import ../../common/values/filesystem-options.nix;
in with filesystemOptions; {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = ESPPreset;
            swap = {
              size = "4G";
              content = swapContentPreset;
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-nvme";
                passwordFile = LUKSPasswordFile;
                settings = LUKSSettingsPreset;
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "60%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
          storage = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = btrfsExtraArgs;
              subvolumes = let
                btrfsMountOptions = [
                  "compress=zstd:1" # Use zstd with fastest compression level
                  "noatime" # Don't update access time reading files
                  "space_cache=v2" # Caches free blocks
                  "ssd" # Explicit SSD optimization
                ];
              in {
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
                "/aether" = {
                  mountpoint = "/mnt/aether";
                  mountOptions = btrfsMountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}
