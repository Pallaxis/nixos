{
  pkgs,
  username,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout" "libvirtd" "wireshark"];
    home = "/home/${username}";
    shell = pkgs.zsh;
  };
  environment.pathsToLink = ["/share/zsh"];
}
