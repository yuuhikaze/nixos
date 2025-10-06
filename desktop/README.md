# Desktop NixOS configuration

### Installation/deployment

Live-boot a minimal NixOS image on the target system, then configure as follows:

```bash
sudo -i # escalate to superuser
loadkeys es # switch to spanish keyboard layout
passwd # change root password

systemctl start sshd # start SSH

dd if=/dev/urandom bs=1 count=32 | base64 > /tmp/pass # generate LUKS decryption key (passed to cryptsetup)
dd if=/dev/urandom of=/tmp/desktop_key bs=4096 count=1 # generate additional LUKS decryption key (redundancy measure, i.e. safeguard)
```

On the executor node:

```bash
# SET UP SOPS
# @source: https://youtube.com/watch?v=G5f6GC7SnhU
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > /tmp/keys.txt # derive private age key from private SSH key
nix shell nixpkgs#age -c age-keygen -y /tmp/keys.txt # display public age key derived from private key
# > Write the value of the private key at `/persist/var/lib/sops-nix/keys.txt` on the target machine
# RUN NIXOS-ANYWHERE
nix run nixpkgs#nixos-anywhere \
  --extra-experimental-features "nix-command flakes" \
  -- --flake '.#generic' \
  --generate-hardware-config nixos-generate-config ./nixos/hardware-configuration.nix \
  root@<target_machine_IP>
# > Enter LUKS passphrase
# ENROLL KEYS ON TPM CHIP
systemd-cryptenroll --tpm-device=auto
```
