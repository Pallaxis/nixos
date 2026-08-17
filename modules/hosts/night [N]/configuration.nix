{inputs, ...}: {
  flake.modules.nixos.night = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      nvidia

      hyprland
    ];
    networking.hostName = "night";
  };
}
