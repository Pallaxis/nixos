{
  flake.modules.nixos.keyd = {
    services.keyd = {
      enable = true;
      keyboards.caps-swap = {
        ids = [
          "*"
          "-046d:4093"
          "-046d:c094"
        ];
        settings = {
          main = {
            capslock = "esc";
            esc = "capslock";
          };
        };
      };
    };
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
