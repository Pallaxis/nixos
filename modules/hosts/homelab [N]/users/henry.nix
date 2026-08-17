{inputs, ...}: {
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      henry
    ];
  };
}
