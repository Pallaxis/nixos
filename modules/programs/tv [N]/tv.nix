{
  flake.modules.nixos.tv = {pkgs, ...}: {
    services = {
      # bigscreen seems to depend on this
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

    # another dependency
    qt.enable = true;

    # strips unneeded default packages
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

    # something to do with the desktop portal
    xdg.portal.configPackages = [pkgs.kdePackages.plasma-bigscreen];

    # some sort of fix for kdeconnect
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

    # unrelated to bigscreen
    environment.systemPackages = with pkgs; [
      vacuum-tube
    ];
  };
}
