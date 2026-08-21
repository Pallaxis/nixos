{inputs, ...}: {
  # my.waybar.enable = false;
  # my.quickshell.enable = true;
  # my.desktop.enable = true;

  flake.modules.nixos.hyprland = {
    pkgs,
    config,
    ...
  }: {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.hyprland
    ];

    programs.hyprland = {
      enable = true;
    };

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.systemd}/bin/systemd-cat -t hyprland ${config.programs.hyprland.package}/bin/start-hyprland";
          user = config.systemConstants.username;
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd \"${pkgs.systemd}/bin/systemd-cat -t hyprland ${config.programs.hyprland.package}/bin/start-hyprland\"";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      tuigreet
      bibata-cursors
    ];
  };

  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    # my.home.services.handleMonitorConnect.enable = false; # TODO: unneeded systemd service, could keep as an example
    home = {
      # file.".config/hypr/scripts".source = ./scripts;
      pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
        hyprcursor.enable = true;
        hyprcursor.size = 24;
        gtk.enable = true;
      };
    };

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];
    };
    services.hyprpolkitagent.enable = true;
    services.dunst.enable = true;
    gtk = {
      enable = true;
      colorScheme = "dark";
    };
    programs.quickshell = {
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
    };
    programs.waybar = {
      systemd.enable = true;
      systemd.targets = ["hyprland-session.target"];
    };
  };
}
