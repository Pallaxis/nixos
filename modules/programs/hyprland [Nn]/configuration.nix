{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    imports = with inputs.self.modules.homeManager; [
      quickshell
    ];
  };
}
