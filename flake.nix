{
  description = "Personal nixos dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    disko,
    nix-index-database,
    ...
  } @ inputs: let
    username = "henry";
    # A helper to reduce boilerplate for any host added to the folder
    mkSystem = hostName:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self inputs hostName username;
        };
        modules = [
          # Modules every host will need
          ./hosts/${hostName}/default.nix
          ./hosts/${hostName}/hardware-configuration.nix
          disko.nixosModules.disko
          # Home manager defined here because I only have 1 user
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs username;};
              users.${username}.imports = [
                ./modules/user.nix
                catppuccin.homeModules.catppuccin
                nix-index-database.homeModules.nix-index
              ];
            };
          }
          {
            nixpkgs.overlays = [
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
    # Disabling for now, unneeded for my setup currently
    # homeConfigurations = {
    #   ${username} = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     extraSpecialArgs = {
    #       inherit inputs username;
    #       osConfig = self.nixosConfigurations.thinkpad.config;
    #     };
    #     modules = [
    #       ./modules/user.nix
    #       catppuccin.homeModules.catppuccin
    #       nix-index-database.homeModules.nix-index
    #     ];
    #   };
    # };
  };
}
