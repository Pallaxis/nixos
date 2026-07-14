{
  inputs,
  username,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs username;};
    users.${username}.imports = [
      ./user.nix
      inputs.catppuccin.homeModules.catppuccin
      inputs.nix-index-database.homeModules.nix-index
    ];
  };
}
