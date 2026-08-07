{
  flake.modules.nixos.pulseaudio = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
