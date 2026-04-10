{lib, ...}: let
  # Maps dirs in current dir to a list of paths
  dirNames = lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
  importPaths = map (name: ./. + "/${name}") dirNames;
in {
  imports = importPaths;
}
