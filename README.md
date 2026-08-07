# Modular NixOS flake with my dotfiles in home-manager user
## Current best way to install (potentially broken)
### Use nixos-anywhere, disko install doesn't have enough memory to install the entire system
```sh
nix run github:nix-community/nixos-anywhere -- --flake ".#thinkpad" --target-host nixos@192.168.122.3 --generate-hardware-config nixos-generate-config ./hosts/thinkpad/hardware-configuration.nix
```

## Local setup
### To setup drive partition btrfs and encrtyption
1. Boot up using the NixOS install media
2. Begin by cloning this repo
```sh
git clone https://github.com/pallaxis/nixos.git ~/nixos && cd ~/nixos
```
3. Create a new dir with your hostname in `modules/hosts/`, can use another system as a template
4. Generate a new hardware-configuration.nix and copy it the host's aspect, i.e `modules/hosts/<host>/hardware.nix`
```sh
nixos-generate-config --no-filesystems --show-hardware-config
```
5. Modify the filesystem.nix in your new host to have the correct drive/device for Disko
6. Now run this to setup partitions/btrfs
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#<host>
```
7. Install the nixos system
```sh
sudo nixos-install --flake .#<host>
```
8. Copy modified repo into `/mnt/home/<user>` so you can keep your new host's config
9. Reboot into new system
