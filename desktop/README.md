# Desktop NixOS configuration

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
systemctl start sshd # start SSH
dd if=/dev/urandom bs=1 count=32 | base64 > /tmp/pass # generate LUKS decryption key (passed to cryptsetup)
mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key -N "" -C ""
# ==> @EXECUTOR <==
# SET UP SOPS
# @source: https://youtube.com/watch?v=G5f6GC7SnhU
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > /tmp/sops-nix # derive private age key from private SSH key
nix shell nixpkgs#age -c age-keygen -y /tmp/sops-nix # display public age key derived from private key
# ==> @TARGET <==
mkdir -p mnt/persist/var/keys
vim /mnt/persist/var/keys/sops-nix # write the value of the private age key
# ==> @EXECUTOR <==
# RUN NIXOS-ANYWHERE
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features "nix-command flakes" \
  -- --flake '.#generic' \
  --generate-hardware-config nixos-facter ./facter.json \
  root@<target_machine_IP>
# UNLOCK LUKS
cat <<< "<pass>" | ssh -p 2224 root@<target_machine_IP>
# ==> @TARGET <==
# ENROLL LUKS DECRYPTION KEYS ON TPM CHIP
# @source: https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html#id-1.5.7.5
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-nvme0n1-luks
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-sda-luks
```

### Post-Install Steps

```bash
# SET UP LANZABOOTE
# Enable
touch lanzaboote-enabled # CWD is relative to flake.nix
# Create keys
sudo sbctl create-keys
# Validate
sudo sbctl verify
# ==> @EXECUTOR <==
nixos-rebuild switch --flake .#generic --target-host root@<target_machine_IP>
# ==> @TARGET <==
# > Reboot, enter BIOS (spam F2)
#     Set "Secure Boot" to enabled
#     Select "Reset to Setup Mode"
# Enroll keys
sudo sbctl enroll-keys --microsoft
# Validate
bootctl status
```

### Manteinance

```bash
nix flake update # Update flake inputs
sudo nixos-rebuild switch --flake .#generic # Switch to updated system
```

### Secrets

```bash
echo -n "<secret>" | mkpasswd -s # hash secret
sops secrets/secret.yaml # edit secrets file
```
