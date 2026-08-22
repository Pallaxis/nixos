{inputs, ...}: {
  flake.modules.nixos.night = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      nvidia

      hyprland
      gaming
      brightness
    ];
    networking.hostName = "night";

    services.ratbagd.enable = true;
  };
}
