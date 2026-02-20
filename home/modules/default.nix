{
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./hyprland
    ./lutris
    ./nvim
    ./scripts
    ./services
    ./ssh
    ./terminal
  ];
  config = {
    my.home.modules =
      {
        ssh.enable = true;
      }
      // lib.optionalAttrs osConfig.my.modules.gaming.enable {
        lutris.enable = true;
      }
      // lib.optionalAttrs (osConfig.my.host.name == "thinkpad") {
      };
    catppuccin = {
      enable = true;
      accent = "blue";
      flavor = "mocha";

      hyprlock.useDefaultConfig = false;
      zsh-syntax-highlighting.enable = false;
      thunderbird.profile = "henry";
      tmux.extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"
        set -ogq @catppuccin_window_text " #W"
        set -ogq @catppuccin_window_current_text " #W"
        set -g status-left ""
        set -g status-right "#{?window_zoomed_flag,#[fg=#{@thm_mauve}]ZOOMED ,}#{E:@catppuccin_status_session}"
      '';
    };
    programs.thunderbird = {
      enable = true;
      profiles = {
        henry = {
          isDefault = true;
          settings = {
            "mailnews.start_page.enabled" = false;
          };
        };
      };
    };
  };
}
