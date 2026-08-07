{
  flake.modules.homeManager.hyprland = {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${./wallpapers/forrest.png}";
          }
        ];
      };
    };
  };
}
