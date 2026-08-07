{inputs, ...}: let
  home-manager-config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      # extraSpecialArgs = {inherit inputs username;};
    };
  };
in {
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.darwin.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      home-manager-config
    ];
  };
}
