{ ... }:

{
  imports = [
    ./packages.nix
    ./system.nix
    ./user.nix
    ./etc-configs.nix
    ./services.nix
  ];
}
