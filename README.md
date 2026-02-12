# Modular NixOS flake with my dotfiles in home-manager user
nix run github:nix-community/nixos-anywhere -- --flake ".#thinkpad" --target-host nixos@192.168.122.3 --generate-hardware-config nixos-generate-config ./hosts/thinkpad/hardware-configuration.nix

## To setup drive partition btrfs and encrtyption
1. Boot up using the NixOS install media
3. Clone this repo: `git clone https://github.com/pallaxis/nixos.git ~/.nixos`
4. Copy hosts/night to hosts/<your-hostname>, then delete the `hardware-configuration.nix` file.
5. Modify the default.nix in your new host to have the right disko settings, as well as any additional configs, i.e hyprland monitors
6. `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ~/.nixos/hosts/<hostname>/disko.nix`
^ WIP: need to figure out the process better, shouldn't need the flake install section below as I've added disko as a module

## To install the flake
1. Install NixOS onto a UEFI capable machine
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
