{inputs, ...}: let
  username = "henry";
in {
  flake.modules.homeManager."${username}" = {pkgs, ...}: {
    imports = [
      inputs.nix-index-database.homeModules.default
    ];
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    # Uses small /bin only db, much faster searches
    programs.nix-index.package = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;
  };
}
