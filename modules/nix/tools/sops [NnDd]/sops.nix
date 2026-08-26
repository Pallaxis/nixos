{inputs, ...}: {
  flake.modules.nixos.sops = {pkgs, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [pkgs.sops];

    sops = {
      age.keyFile = "/etc/sops/age/system-core-age-key.txt";
      defaultSopsFile = ../../secrets/system.yaml;
    };
  };

  flake.modules.darwin.sops = {pkgs, ...}: {
    imports = [
      inputs.sops-nix.darwinModules.sops
    ];

    environment.systemPackages = [pkgs.sops];

    sops = {
      age.keyFile = "/etc/sops/age/system-core-age-key.txt";
      defaultSopsFile = ../../secrets/system.yaml;
    };
  };

  flake.modules.homeManager.sops = {pkgs, ...}: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    home.packages = [pkgs.sops];
  };
}
