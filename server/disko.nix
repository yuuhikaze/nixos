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
                  "ro"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/secret.key";
                # Enable TRIM support: helps SSDs manage deleted blocks efficiently
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = [
                  # Automatically use TPM2 device for unlocking the LUKS volume
                  "tpm2-device=auto"
                  # Extend PCRs for TPM-based integrity checking
                  "tpm2-measure-pcr=yes"
                ];
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
          swap = {
            size = "4G";
            content = {
              type = "swap";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
