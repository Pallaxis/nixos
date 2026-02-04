{pkgs, ...}: {
  users.users.henry = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout"];
    home = "/home/henry";
    shell = pkgs.zsh;
  };
}
