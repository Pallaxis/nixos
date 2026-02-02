{
  description = "Personal nixos dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # A helper to reduce boilerplate for any host added to the folder
    mkSystem = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit host;
        };
        modules = [
          # Modules every host will need
          ./hosts/${host}/default.nix
          ./hosts/${host}/hardware-configuration.nix
          # Home manager defined here because I only have 1 user
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.henry = import ./users/henry/home.nix;
          }
        ];
      };
  in {
    nixosConfigurations = {
      night = mkSystem "night";
      thinkpad = mkSystem "thinkpad";
      mist = mkSystem "mist";
    };
  };
}
