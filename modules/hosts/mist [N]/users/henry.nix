{inputs, ...}: {
  flake.modules.nixos.mist = {
    imports = with inputs.self.modules.nixos; [
      henry
    ];
  };
}
