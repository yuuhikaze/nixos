# Common NixOS Configuration

### Installation/deployment

> [!CAUTION] Disable CSM support and Secure Boot (the latter will be enabled afterwards)

Live-boot a minimal NixOS image on the target machine, then configure as follows:

> Executor: machine where you'll run nixos-anywhere from
>
> Target: machine on which NixOS will be installed upon

```bash
# ==> @TARGET <==
sudo -i # escalate to superuser
loadkeys es # switch to spanish keyboard layout
passwd # change root password
systemctl start sshd # start SSH service
dd if=/dev/urandom bs=1 count=32 | base64 > /tmp/pass # generate LUKS decryption key
# > [!] Wipe unused boot partitions (efibootmgr)
# ==> @EXECUTOR <==
# Run nixos-anywhere (phase kexec,disko)
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features 'nix-command flakes' \
  -- --flake 'path:.#<machine>' \
  --phases 'kexec,disko' \
  --generate-hardware-config nixos-facter ./facter.json \
  --show-trace \
  'root@<target_machine_IP>'
# ==> @TARGET <==
# Set up SSH hosts
mkdir -p /mnt/persist/etc/secrets/initrd
ssh-keygen -t ed25519 -f /mnt/persist/etc/secrets/initrd/ssh_host_ed25519_key -N "" -C ""
chmod 400 /mnt/persist/etc/secrets/initrd/*
# Set age private key
mkdir -p /mnt/persist/var/keys
vim /mnt/persist/var/keys/sops-nix
# ==> @EXECUTOR <==
# Run nixos-anywhere (phase install,reboot)
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features 'nix-command flakes' \
  -- --flake 'path:.#<machine>' \
  --phases 'install,reboot' \
  --show-trace \
  'root@<target_machine_IP>'
# Unlock LUKS
# @source: https://discourse.nixos.org/t/unlocking-luks-in-initrd-with-systemd-enabled-through-ssh/31052/2
cat <<< "<pass>" | ssh -p 2224 root@192.168.100.14 systemd-tty-ask-password-agent
```

### Post-Install Steps

Let's now enable secure boot

```bash
# ==> @EXECUTOR <==
touch lanzaboote-enabled # enable Lanzaboote, CWD is relative to <host>/README.md
# ==> @TARGET <==
sudo sbctl create-keys
sudo sbctl verify # validate
# ==> @EXECUTOR <==
nix run nixpkgs#nixos-rebuild \
  --extra-experimental-features 'nix-command flakes' \
  -- switch --flake 'path:.#<machine>' \
  --target-host 'root@<target_machine_IP>'
# ==> @TARGET <==
# > Reboot, enter BIOS
#     Set UEFI password
#     Set "Secure Boot" to enabled
#     Select "Reset to Setup Mode"
sudo sbctl enroll-keys --microsoft
bootctl status # validate
# Enroll LUKS decryption keys on TPM chip
# @source: https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html#id-1.5.7.5
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-nvme0n1-luks
# Since both devices share the same decryption passphrase, the following is not necessary:
# sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-sda-luks
```

### Secrets

```bash
# ==> SOPS-NIX <==
# Set up identity/authentication
# @source: https://youtube.com/watch?v=G5f6GC7SnhU
nix run nixpkgs#ssh-to-age \
  --extra-experimental-features 'nix-command flakes' \
  -- -private-key -i ~/.ssh/id_ed25519 > /var/keys/sops-nix # derive private age key from private SSH key
# Display public age key derived from private key
# Set value on `&primary` field of `.sops.yaml` file
nix shell nixpkgs#age \
  --extra-experimental-features 'nix-command flakes' \
  -c age-keygen -y /var/keys/sops-nix
# Generate, edit secrets file
nix run nixpkgs#sops \
  --extra-experimental-features 'nix-command flakes' \
  -- secrets.yaml
```

# Manteinance

### Update Packages

```bash
nix flake update # update flake inputs
sudo nixos-rebuild switch --flake path:.#generic # switch to updated system
```

### Garbage Collection

```bash
# ==> PACKAGES <==
# Query unused store paths
nix-store --gc --print-live --debug
# Delete unreferenced store paths
sudo nix-collect-garbage
# ==> SYSTEM <==
# Delete old generations of current profile
nix-collect-garbage -d
```

### Impermanence

When declaring a new file or directory as non-impermanent, first move it to persistent storage, then rebuild the system.
