{
  lib,
  username,
  ...
}: let
  entries = builtins.readDir ./.;

  importPaths =
    lib.mapAttrsToList
    (name: _: ./. + "/${name}/home.nix")
    (lib.filterAttrs
      (name: type:
        type
        == "directory"
        && builtins.pathExists (./. + "/${name}/home.nix"))
      entries);
in {
  imports = importPaths;

  # Basic user info
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Pallaxis";
          email = "sam_e3u@hotmail.com";
        };
        diff = {
          tool = "nvimdiff";
        };
        difftool = {
          nvimdiff = {
            cmd = "nvim -c 'DiffviewOpen $LOCAL..$REMOTE'";
          };
        };
      };
    };
  };

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;
}
