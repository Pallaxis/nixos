{
  flake.modules.homeManager.sops = {config, ...}: {
    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/henry-age-key.txt";
      defaultSopsFile = ../../../secrets/core.yaml;
    };
  };
}