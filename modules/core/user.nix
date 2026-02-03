{pkgs, ...}: {
  users.users.henry = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    home = "/home/henry";
    shell = pkgs.zsh;
  };
}
