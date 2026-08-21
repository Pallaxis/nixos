{inputs, ...}: {
  flake.modules.nixos.nixflix = {
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.nixflix.nixosModules.default
    ];

    services.homepage-dashboard = {
      # enable = true;
    };

    nixflix = {
      enable = true;
      mediaUsers = lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser) config.users.users);

      theme = {
        enable = true;
        name = "overseerr";
      };
      postgres.enable = true;

      nginx = {
        enable = true;
        addHostsEntries = true;
        domain = "paradise.net";
      };
    };
  };
}
