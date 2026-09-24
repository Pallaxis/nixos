{inputs, ...}: {
  flake.modules.nixos.homelab = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-cli
      ssh
      nixflix
      blocky

      tv
    ];
    networking.hostName = "homelab";

    security.sudo.wheelNeedsPassword = false;

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };
    environment.systemPackages = with pkgs; [libva-utils];
  };
}
