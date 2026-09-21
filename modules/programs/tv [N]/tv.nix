{
  flake.modules.nixos.tv = {pkgs, ...}: {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [pkgs.kdePackages.plasma-bigscreen];
    };

    qt.enable = true;

    environment.systemPackages = with pkgs.kdePackages; [
      plasma-bigscreen
      plasma-workspace
      kwin
      plasma-integration
      libplasma
    ];

    nixpkgs.overlays = [
      (final: prev: {
        kdePackages =
          prev.kdePackages
          // {
            plasma-bigscreen = prev.kdePackages.plasma-bigscreen.overrideAttrs (old: {
              buildInputs = (old.buildInputs or []) ++ [prev.kdePackages.kdeconnect-kde];
              preFixup = ''
                wrapQtApp $out/bin/plasma-bigscreen-wayland \
                  --prefix QML2_IMPORT_PATH : "${prev.kdePackages.kdeconnect-kde}/lib/qt-6/qml"
              '';
            });
          };
      })
    ];
  };
}
