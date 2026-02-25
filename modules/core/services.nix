{pkgs, ...}: {
  services.udisks2.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  services.keyd = {
    enable = true;
    keyboards.caps-swap = {
      settings = {
        main = {
          capslock = "esc";
          esc = "capslock";
        };
      };
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
