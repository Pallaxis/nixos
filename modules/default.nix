{lib, ...}: let
  entries = builtins.readDir ./.;

  importPaths =
    lib.mapAttrsToList
    (name: _: ./. + "/${name}/nixos.nix")
    (lib.filterAttrs
      (name: type:
        type
        == "directory"
        && builtins.pathExists (./. + "/${name}/nixos.nix"))
      entries);
in {
  imports = importPaths;
}
