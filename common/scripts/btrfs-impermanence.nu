#!/usr/bin/env nix-shell
#! nix-shell -i nu --pure
#! nix-shell -p nushell btrfs-progs coreutils util-linux
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz

# Post-order traversal algorithm
def delete-subvolume-recursively [path: string] {
    let raw = btrfs subvolume list -o $path | detect columns --no-headers
    let children = if ($raw | is-empty) {
        []
    } else {
        $raw | get column8
    }
    for child in $children {
        delete-subvolume-recursively $'/btrfs_tmp/($child)'
    }
    btrfs subvolume delete $path
}

# Mount all subvolumes at /btrfs_tmp
mkdir /btrfs_tmp
mount -o subvol=/ /dev/mapper/crypted-nvme /btrfs_tmp

# Archive current root subvolume
mkdir /btrfs_tmp/old_roots
let timestamp = ls -lD /btrfs_tmp/root | update created {format date %s} | get created | first
mv /btrfs_tmp/root $"/btrfs_tmp/old_roots/($timestamp)"

# Define three most recent archived root subvolumes
let all_roots = (ls /btrfs_tmp/old_roots | sort-by name --reverse)
let excess = ($all_roots | skip 3 | get name)

# Delete archived root subvolumes in excess
for root in $excess {
    print $root
    delete-subvolume-recursively $root
}

# Create blank root subvolume
btrfs subvolume create /btrfs_tmp/root

# Unmount all subvolumes from tmp dir
umount /btrfs_tmp
