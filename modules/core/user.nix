{pkgs, ...}: {
  users.users.henry = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout" "libvirtd" "wireshark"];
    home = "/home/henry";
    shell = pkgs.zsh;
  };
  environment.pathsToLink = ["/share/zsh"];
}
