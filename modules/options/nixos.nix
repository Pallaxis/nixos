{
  lib,
  hostname,
  ...
}: {
  options.my = with lib; {
    host = {
      name = mkOption {
        type = types.str;
        default = hostname;
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
    modules.allowedUnfreePkgs = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
}
