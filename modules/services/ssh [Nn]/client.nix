{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    services.ssh-agent = {
      enable = true;
      socket = "ssh-agent.socket";
    };
  };
}
