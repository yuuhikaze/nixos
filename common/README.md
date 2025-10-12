# Common NixOS configuration

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
# ==> @EXECUTOR <==
# Run nixos-anywhere (phase kexec,disko)
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features "nix-command flakes" \
  -- --flake '.#generic' \
  --generate-hardware-config nixos-facter ./facter.json \
  --phases "kexec,disko" \
  root@<target_machine_IP>
# ==> @TARGET <==
# Set up SSH hosts
mkdir -p /mnt/persist/etc/secrets/initrd
ssh-keygen -t ed25519 -f /mnt/persist/etc/secrets/initrd/ssh_host_ed25519_key -N "" -C ""
chmod 600 /mnt/persist/etc/secrets/initrd/ssh_host_ed25519_key
# Set age private key
mkdir -p /mnt/persist/var/keys
vim /mnt/persist/var/keys/sops-nix
# ==> @EXECUTOR <==
# Run nixos-anywhere (phase install,reboot)
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features "nix-command flakes" \
  -- --flake '.#generic' \
  --phases "install,reboot" \
  root@<target_machine_IP>
# Unlock LUKS
cat <<< "<pass>" | ssh -p 2224 root@<target_machine_IP>
# ==> @TARGET <==
# Enroll LUKS decryption keys on TPM chip
# @source: https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html#id-1.5.7.5
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-nvme0n1-luks
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-sda-luks
```

### Post-Install Steps

Let's now enable secure boot

```bash
# ==> @TARGET <==
touch lanzaboote-enabled # enable Lanzaboote, CWD is relative to README.md
sudo sbctl create-keys
sudo sbctl verify # validate
# ==> @EXECUTOR <==
nix run nixpkgs#nixos-rebuild \
  --extra-experimental-features "nix-command flakes" \
  -- switch --flake .#generic \
  --target-host root@<target_machine_IP>
# ==> @TARGET <==
# > Reboot, enter BIOS (spam F2)
#     Set "Secure Boot" to enabled
#     Select "Reset to Setup Mode"
sudo sbctl enroll-keys --microsoft
bootctl status # validate
```

### Manteinance

```bash
nix flake update # update flake inputs
sudo nixos-rebuild switch --flake .#generic # switch to updated system
```

### Secrets

```bash
# ==> SOPS-NIX <==
# @source: https://youtube.com/watch?v=G5f6GC7SnhU
# Set up identity/authentication
nix run nixpkgs#ssh-to-age \
  --extra-experimental-features "nix-command flakes" \
  -- -private-key -i ~/.ssh/id_ed25519 > /var/keys/sops-nix # derive private age key from private SSH key
# Display public age key derived from private key
# Set value on `&primary` field of `.sops.yaml` file
nix shell nixpkgs#age \
  --extra-experimental-features "nix-command flakes" \
  -c age-keygen -y /var/keys/sops-nix
# Generate, edit secrets file
nix run nixpkgs#sops \
  --extra-experimental-features "nix-command flakes" \
  -- secrets.yaml
```
