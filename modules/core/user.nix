{ pkgs, ... }:

{
  users.users.henry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/henry";
    shell = pkgs.zsh;
  };
}
