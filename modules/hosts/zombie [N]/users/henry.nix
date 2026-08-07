{inputs, ...}: {
  flake.modules.nixos.zombie = {
    imports = with inputs.self.modules.nixos; [
      henry
    ];
  };
}
