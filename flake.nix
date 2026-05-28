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
    # A helper to reduce boilerplate for any host added to the folder
    mkSystem = hostName:
      nixpkgs.lib.nixosSystem {
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
              nix-index-database.homeModules.nix-index
            ];
          }
          {
            nixpkgs.overlays = [
              # FIXME: https://github.com/NixOS/nixpkgs/issues/514113
              (_: prev: {
                openldap = prev.openldap.overrideAttrs {
                  doCheck = !prev.stdenv.hostPlatform.isi686;
                };
              })
              # FIXME: https://github.com/nixos/nixpkgs/issues/523200
              (_final: prev: let
                stable = import self.inputs.nixpkgs-stable {
                  inherit (prev.stdenv.hostPlatform) system;
                  config.allowUnfree = true;
                };
              in {
                inherit (stable) bubblewrap;
              })
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
