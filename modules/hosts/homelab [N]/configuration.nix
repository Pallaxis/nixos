{inputs, ...}: {
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      system-desktop

      ssh
      nixflix
    ];
    networking.hostName = "homelab";

    security.sudo.wheelNeedsPassword = false;
  };
}
