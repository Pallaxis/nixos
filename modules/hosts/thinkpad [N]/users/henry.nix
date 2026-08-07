{inputs, ...}: {
  flake.modules.nixos.thinkpad = {
    imports = with inputs.self.modules.nixos; [
      henry
    ];
  };
}
