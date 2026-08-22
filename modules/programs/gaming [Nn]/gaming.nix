{inputs, ...}: {
  flake.modules.nixos.gaming = {pkgs, ...}: {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.gaming
    ];

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamescope = {
        enable = true;
        # FIXME: https://github.com/nixos/nixpkgs/issues/523200
        capSysNice = false;
      };
    };

    environment.systemPackages = with pkgs; [
      # gamma-launcher
      protonup-ng
      wineWow64Packages.stagingFull
      winetricks
    ];
  };

  flake.modules.homeManager.gaming = {pkgs, ...}: {
    programs = {
      vesktop.enable = true;
      lutris = {
        enable = true;
        extraPackages = with pkgs; [
          umu-launcher
        ];
        protonPackages = [
          pkgs.proton-ge-bin
        ];
      };
      mangohud.enable = true;
    };
    xdg.configFile."gamescope/scripts/stutter-fix.lua".text = ''
      function info(text)
        gamescope.log(gamescope.log_priority.info, text)
      end

      info("Enabling explicit sync: " .. tostring(gamescope.convars.drm_debug_disable_explicit_sync.value) .. " -> " .. tostring(true))
      gamescope.convars.drm_debug_disable_explicit_sync.value = true
    '';
  };
}
