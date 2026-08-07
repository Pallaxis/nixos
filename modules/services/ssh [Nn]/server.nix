{
  flake.modules.nixos.ssh = {
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
