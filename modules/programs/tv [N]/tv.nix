{
  flake.modules.nixos.tv = {pkgs, ...}: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        defaultSession = "plasma-bigscreen-wayland";
        sessionPackages = [pkgs.kdePackages.plasma-bigscreen];
      };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      ark
      baloo-widgets
      discover
      dolphin
      dolphin-plugins
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      ktexteditor
      okular
      plasma-browser-integration
      spectacle
    ];

    xdg.portal.configPackages = [pkgs.kdePackages.plasma-bigscreen];

    qt.enable = true;

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

    environment.systemPackages = with pkgs; [
      vacuum-tube
    ];
  };
}
