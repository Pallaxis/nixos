{inputs, ...}: {
  # imports = [
  #   ../../modules
  #   ../../profiles/core.nix
  #   ../../profiles/desktop.nix
  # ];
  flake.modules.nixos.mist = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      system-desktop

      hyprland
    ];
    networking.hostName = "mist";

    # Fixes touchpad not disabling while typing
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="05ac", ENV{ID_MODEL_ID}=="02*", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
    '';

    # Needed for stupid broadcom-wl driver
    nixpkgs.config.permittedInsecurePackages = [
      "broadcom-sta-6.30.223.271-63-6.18.41"
    ];
    boot = {
      kernelModules = ["kvm-intel" "wl"];
      extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
      kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;
    };
  };
}
