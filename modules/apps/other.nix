{ pkgs, ... }:

{

  virtualisation.virtualbox.host.enable = true;
  # virtualization.virtualbox.host.enable = true;
  environment.systemPackages = with pkgs; [
    virtualbox
  ];
}
