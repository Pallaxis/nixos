{...}: {
  # sudo password timeout
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=15
  '';
  nixpkgs.config.allowUnfree = true;
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
