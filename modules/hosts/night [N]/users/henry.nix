{inputs, ...}: {
  flake.modules.nixos.night = {
    imports = with inputs.self.modules.nixos; [
      henry
    ];
  };
}
