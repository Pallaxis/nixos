{
  description = "Personal nixos dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager= {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: 
    let
      # A helper to reduce boilerplate for any host added to the folder
      mkSystem = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/${host}/default.nix ];
      };
    in {
      nixosConfigurations = {
        night = mkSystem "night";
        thinkpad = mkSystem "thinkpad";
        mist = mkSystem "mist";
      };
    };
}
