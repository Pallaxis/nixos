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
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    username = "henry";

    hosts =
      builtins.filter
      (name: builtins.pathExists (./hosts + "/${name}/default.nix"))
      (builtins.attrNames (builtins.readDir ./hosts));

    # A helper to reduce boilerplate for any host added to the folder
    mkSystem = hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit self inputs hostname username;
        };
        modules = [
          ./hosts/${hostname}
          ./modules/home-manager.nix
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.nixflix.nixosModules.default
          {
            nixpkgs.overlays = [
            ];
          }
        ];
      };
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;
  };
}
