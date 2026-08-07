{
  flake.modules.homeManager.hyprland = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          immediate_render = true;
          ignore_empty_input = true;
        };
        background = {
          monitor = "";
          path = "${./wallpapers/forrest.png}";
          blur_passes = "4";
          blur_size = "1";
        };
        label = {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "1%, -1%";
          halign = "left";
          valign = "top";
        };
        input-field = {
          monitor = "";
          size = "300, 60";
          outline_thickness = "4";
          dots_size = "0.2";
          dots_spacing = "0.2";
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$subtext0";
          font_family = "JetBrainsMono Nerd Font";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$subtext0Alpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
