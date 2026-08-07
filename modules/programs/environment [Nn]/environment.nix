{
  flake.modules.nixos.environment = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      age
      brightnessctl
      fd
      file
      fzf
      gdu
      git
      glib
      grimblast
      imagemagick
      imv
      jq
      ldns
      libsForQt5.qt5ct
      man-pages
      mpv
      nethogs
      nmap
      nodejs
      parallel
      pavucontrol
      python3
      quickshell
      sops
      tcpdump
      udisks
      unrar
      unzip
      usbutils
      wl-clipboard
      zip
    ];
  };

  flake.modules.homeManager.environment = {pkgs, ...}: let
    logoutMenu = pkgs.writeShellScriptBin "logout-menu" ''
      # Simple app launcher that shows a list of options and handles them by on a case basis
      options=$(printf " Lock\n󰤄 Sleep\n⏻ Power Off\n Reboot\n󰗽 Logout")

      selection=$(${pkgs.procps}/bin/pkill fuzzel || echo -e "''$options" | ${pkgs.fuzzel}/bin/fuzzel --dmenu -i --placeholder "Search")

      [[ -z "''$selection" ]] && exit 0 # exit on no selection

      case "''$selection" in
          " Lock")
              sleep 0.5
              ${pkgs.systemd}/bin/loginctl lock-session
              ;;
          "󰤄 Sleep")
              ${pkgs.systemd}/bin/systemctl suspend
              ;;
          "⏻ Power Off")
              ${pkgs.hyprshutdown}/bin/hyprshutdown --top-label "Shutting down..." --post-cmd "${pkgs.systemd}/bin/systemctl poweroff"
              ;;
          " Reboot")
              ${pkgs.hyprshutdown}/bin/hyprshutdown --top-label "Rebooting..." --post-cmd "${pkgs.systemd}/bin/systemctl reboot"
              ;;
          "󰗽 Logout")
              ${pkgs.hyprshutdown}/bin/hyprshutdown --top-label "Logging out..." --post-cmd "${pkgs.systemd}/bin/loginctl terminate-user """
              ;;
          *)
              echo "how did we get here"
              ;;
      esac
    '';
  in {
    home.packages =
      [logoutMenu]
      ++ (with pkgs; [
        cowsay
        fastfetch
        fortune
        keepassxc
        lolcat
        nerd-fonts.jetbrains-mono
      ]);
    fonts.fontconfig.enable = true;
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          horizontal-pad = 41;
        };
      };
    };
  };
}
