{...}: {
  # sudo password timeout
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=15
  '';
  nixpkgs.config.allowUnfree = true;
  documentation.man.cache.enable = true;
  documentation.man.cache.generateAtRuntime = true;
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
