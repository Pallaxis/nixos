{inputs, ...}: {
  # imports = [
  #   ../../modules
  #   ../../profiles/core.nix
  #   ../../profiles/desktop.nix
  # ];
  flake.modules.nixos.zombie = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      systemd-boot

      nvidia
      hyprland
    ];
    networking.hostName = "zombie";

    services.hardware.openrgb.enable = true;
  };
}
