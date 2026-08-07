{
  flake.modules.homeManager.ssh = {
    services = {
      ssh-agent = {
        enable = true;
        socket = "ssh-agent.socket";
      };
    };
  };
}
