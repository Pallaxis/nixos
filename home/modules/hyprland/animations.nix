{
  osConfig,
  lib,
  ...
}:
lib.mkIf osConfig.my.modules.hyprland.enable {
  wayland.windowManager.hyprland = {
    settings = {
      animation = [
        "workspaces, 0, 1, wind, fade"
        "specialWorkspace, 0"
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 6, winIn, popin"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 0, 5, wind, slide"
        "border, 1, 1, liner"
        "borderangle, 1, 30, liner, once # Loop uses more cpu"
        "fade, 1, 10, default"
      ];
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
    };
  };
}
