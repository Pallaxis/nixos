{pkgs, ...}: {
  users.users.henry = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout" "libvirtd"];
    home = "/home/henry";
    shell = pkgs.zsh;
  };
}
