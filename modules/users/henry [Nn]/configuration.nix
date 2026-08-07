{inputs, ...}: let
  username = "henry";
in {
  flake.modules.nixos."${username}" = {pkgs, ...}: {
    home-manager.users."${username}" = {
      imports = [
        inputs.self.modules.homeManager."${username}"
      ];
    };

    users.users."${username}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "dialout" "libvirtd" "wireshark"];
      home = "/home/${username}";
      initialPassword = "changeme";
      shell = pkgs.zsh;
    };

    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;
  };

  flake.modules.homeManager."${username}" = {
    imports = with inputs.self.modules.homeManager; [
      system-desktop
      catppuccin
      tmux
    ];
  };
}
