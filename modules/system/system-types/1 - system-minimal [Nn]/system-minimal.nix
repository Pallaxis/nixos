{inputs, ...}: {
  flake.modules.nixos.system-minimal = {pkgs, ...}: {
    nixpkgs.overlays = [
      (final: _prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (final) config;
          system = pkgs.stdenv.hostPlatform.system;
        };
      })
    ];

    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "25.11"; # Don't ever change this
    system.configurationRevision = inputs.rev or inputs.dirtyRev or null;

    security.sudo.extraConfig = ''
      Defaults        timestamp_timeout=15
    '';

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 1024 * 1024 * 1024;
    };

    documentation.man.cache.enable = true;
    documentation.man.cache.generateAtRuntime = true;
  };

  flake.modules.homeManager.system-minimal = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.homeDirectory =
      if pkgs.stdenv.isDarwin
      then (lib.mkForce "/Users/${config.home.username}")
      else "/home/${config.home.username}";
    home.stateVersion = "26.05";
  };
}
