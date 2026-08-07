{
  flake.modules.homeManager.hyprland = {
    qt = {
      enable = true;
      style.name = "kvantum";
      qt5ctSettings = {
        Appearance = {
          style = "kvantum";
          custom_palette = "true";
          color_scheme_path = "/home/henry/.config/qt5ct/style-colors.conf";
        };
      };
      qt6ctSettings = {
        Appearance = {
          style = "kvantum";
          custom_palette = "true";
          color_scheme_path = "/home/henry/.config/qt6ct/style-colors.conf";
        };
      };
    };
    xdg.configFile."qt5ct/style-colors.conf".text = ''
      [ColorScheme]
      active_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff45475a, #ff181825, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff181825, #ff1e1e2e, #ff000000, #4d89b4fa, #ffcdd6f4, #ff89b4fa, #ff97bbf9, #ff181825, #ff000000, #ff181825, #ffcdd6f4, #80cdd6f4
      disabled_colors=#ffbebebe, #ffefefef, #ffffffff, #ffcacaca, #ffbebebe, #ffb8b8b8, #ffbebebe, #ffffffff, #ffbebebe, #ffefefef, #ffefefef, #ffb1b1b1, #ff919191, #ffffffff, #ff0000ff, #ffff00ff, #fff7f7f7, #ff000000, #ffffffdc, #ff000000, #80000000
      inactive_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff45475a, #ff181825, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff181825, #ff1e1e2e, #ff000000, #4d89b4fa, #ffcdd6f4, #ff89b4fa, #ff97bbf9, #ff181825, #ff000000, #ff181825, #ffcdd6f4, #80cdd6f4
    '';
  };
}
