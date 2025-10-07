# Desktop NixOS configuration

### Installation/deployment

> [!CAUTION] Disable CSM support and Secure Boot (the latter will be enabled afterwards)

Live-boot a minimal NixOS image on the target system, then configure as follows:

```bash
sudo -i # escalate to superuser
loadkeys es # switch to spanish keyboard layout
passwd # change root password

systemctl start sshd # start SSH

dd if=/dev/urandom bs=1 count=32 | base64 > /tmp/pass # generate LUKS decryption key (passed to cryptsetup)
dd if=/dev/urandom of=/tmp/desktop_key bs=4096 count=1 # generate additional LUKS decryption key (redundancy measure, i.e. safeguard)

mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key -N "" -C ""
```

On the executor node:

```bash
# SET UP SOPS
# @source: https://youtube.com/watch?v=G5f6GC7SnhU
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > /tmp/keys.txt # derive private age key from private SSH key
nix shell nixpkgs#age -c age-keygen -y /tmp/keys.txt # display public age key derived from private key
# > Write the value of the private key at `/mnt/persist/var/lib/sops-nix/keys.txt` on the target machine
# RUN NIXOS-ANYWHERE
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features "nix-command flakes" \
  -- --flake '.#generic' \
  --generate-hardware-config nixos-facter ./facter.json \
  root@<target_machine_IP>
# > Enter LUKS passphrase
# UNLOCK LUKS
cat <<< "<pass>" | ssh -p 2224 root@<target_machine_IP>
```

Back on the target machine:

```bash
# ENROLL LUKS DECRYPTION KEYS ON TPM CHIP
# @source: https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html#id-1.5.7.5
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-nvme0n1-luks
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+4+7+15 /dev/disk/by-partlabel/disk-sda-luks
# LANZABOOTE
# Create keys
sbctl create-keys
# Validate
sbctl verify
# > Enter secure Boot Setup Mode
# Enroll keys
sbctl enroll-keys --microsoft
# > Reboot
# Validate
bootctl status
```

### Manteinance

```bash
nix flake update # Update flake inputs
sudo nixos-rebuild switch --flake .#generic # Switch to updated system
```
