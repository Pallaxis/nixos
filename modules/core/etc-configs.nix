{ ... }:

{
  # sudo password timeout
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=15
  '';
  nixpkgs.config.allowUnfree = true;
}
