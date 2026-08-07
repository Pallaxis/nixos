{
  flake.modules.nixos.ddcutil = {pkgs, ...}: {
    environment = with pkgs; [
      ddcutil
    ];

    hardware.i2c.enable = true;
    users.users."henry" = {
      extraGroups = ["i2c"];
    };
  };
}
