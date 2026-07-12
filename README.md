# Modular NixOS flake with my dotfiles in home-manager user
## Current best way to install
### Use nixos-anywhere, disko install doesn't have enough memory to install the entire system
```sh
nix run github:nix-community/nixos-anywhere -- --flake ".#thinkpad" --target-host nixos@192.168.122.3 --generate-hardware-config nixos-generate-config ./hosts/thinkpad/hardware-configuration.nix
```

## Manually with disko, then installing the flake
### To setup drive partition btrfs and encrtyption
1. Boot up using the NixOS install media
```sh
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko,mount \
  --flake github:pallaxis/nixos/homelab.#homelab
```
3. Clone this repo: `git clone https://github.com/pallaxis/nixos.git ~/.nixos`
4. Create a new dir with your hostname in `hosts/`, then copy default.nix from another system
5. Generate a new hardware-configuration.nix and put in that dir `nixos-generate-config --no-filesystems`
5. Modify the default.nix in your new host to have the right disko settings
6. Finally run this to setup partitions/btrfs
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake ~/.nixos/hosts/<hostname>/disko.nix`
```

### To install the flake
1. Run through the nix-install
2. Install git in temp shell: `nix-shell -p git` (You can also install neovim/other editor here)
3. Enable flakes & set hostname in /etc/nixos/configuration.nix
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
networking.hostName = "<hostname_here>";
```
4. Reboot for hostname to take effect
5. Clone this repo: `git clone https://github.com/pallaxis/nixos.git ~/.nixos`
6. Copy hardware-configuration.nix into the host folder if it differs `cp /etc/nixos/hardware-configuration.nix ~/.nixos/hosts/<name>/` (Don't forget to stage the files in git if you do add one)
7. Run `sudo nixos-rebuild switch --flake ~/.nixos` (Make sure there's a matching hosts/\<name\>/default.nix file for your hostname)
8. Solve errors as they come Xd
