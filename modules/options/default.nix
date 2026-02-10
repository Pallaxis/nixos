{
  lib,
  inputs,
  system,
  hostName,
  ...
}: {
  options.my = with lib; {
    host = {
      name = mkOption {
        type = types.str;
        default = hostName;
      };
      # system = mkOption {
      #   type = types.enum inputs.flake-utils.lib.allSystems;
      #   default = system;
      # };
      role = mkOption {
        type = types.enum [
          "desktop"
          "server"
        ];
        description = "The role this machine has";
      };
    };
    user = {
      name = mkOption {
        type = types.str;
        default = "henry";
      };
      # fullName = mkOption {
      #   type = types.str;
      #   default = "First Last";
      # };
      # email = mkOption {
      #   type = types.str;
      #   default = "email@email.com";
      # };
      signingKey = mkOption {
        type = types.str;
      };
    };
    modules.allowedUnfreePkgs = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
}
