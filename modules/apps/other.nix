{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "henry" ];
  # # virtualization.virtualbox.host.enable = true;
  # environment.systemPackages = with pkgs; [
  #   virtualbox
  # ];

  home-manager.users.henry = {
    programs.gemini-cli.enable = true;
  };
}
