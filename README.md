# Modular NixOS flake with my dotfiles in home-manager user
## Install from live iso
### To setup drive partition btrfs and encrtyption
1. Boot up using the NixOS install media
2. Begin by cloning this repo
```sh
git clone https://github.com/pallaxis/nixos.git ~/nixos && cd ~/nixos
```
3. Create a new dir with your hostname in `modules/hosts/`, can use another system as a template
4. Generate a new hardware-configuration.nix and copy it the host's aspect, i.e `modules/hosts/$HOST/hardware.nix`
```sh
nixos-generate-config --no-filesystems --show-hardware-config
```
5. Modify the filesystem.nix in your new host to have the correct drive/device for Disko
6. Now run this to setup partitions/btrfs
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#$HOST
```
7. Install the nixos system
```sh
sudo nixos-install --flake .#$HOST
```
8. Copy modified repo into `/mnt/home/$USER` so you can keep your new host's config
9. Reboot into new system

## Remote install (broken with new dendritic setup)
### Using nixos-anywhere
```sh
nix run github:nix-community/nixos-anywhere -- --flake .#$HOST --target-host nixos@$IP --generate-hardware-config nixos-generate-config ./hosts/$HOST/hardware-configuration.nix
```
