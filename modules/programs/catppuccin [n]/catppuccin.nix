{inputs, ...}: {
  flake.modules.homeManager.catppuccin = {pkgs, ...}: {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];
    catppuccin = {
      enable = true;
      autoEnable = true;
      sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (final: prev: {
        whiskers = pkgs.catppuccin-whiskers;
      });
    };
  };
}
