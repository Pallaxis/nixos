{inputs, ...}: {
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      system-cli
      ssh
      nixflix
      blocky

      tv
    ];
    networking.hostName = "homelab";

    security.sudo.wheelNeedsPassword = false;
  };
}
