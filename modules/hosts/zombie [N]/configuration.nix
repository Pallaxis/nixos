{inputs, ...}: {
  flake.modules.nixos.zombie = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      nvidia

      hyprland
    ];
    networking.hostName = "zombie";

    services.hardware.openrgb.enable = true;
  };
}
