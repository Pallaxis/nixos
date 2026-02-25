{
  description = "Personal nixos dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    disko,
    ...
  } @ inputs: let
    # A helper to reduce boilerplate for any host added to the folder
    mkSystem = hostName:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit hostName;
        };
        modules = [
          # Modules every host will need
          ./hosts/${hostName}/default.nix
          ./hosts/${hostName}/hardware-configuration.nix
          disko.nixosModules.disko
          # Home manager defined here because I only have 1 user
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.henry.imports = [
              ./home/henry.nix
              catppuccin.homeModules.catppuccin
            ];
          }
        ];
      };
  in {
    nixosConfigurations = {
      night = mkSystem "night";
      thinkpad = mkSystem "thinkpad";
      # mist = mkSystem "mist";
    };
    homeConfigurations = {
      henry = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [./home/henry.nix];
      };
    };
  };
}
