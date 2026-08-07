{inputs, ...}: {
  # this is kinda scuffed, it will add ssh config regardless of if ssh is enabled on the system
  # looking for a better way to keep it self contained
  flake.modules.nixos.thinkpad = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.ssh
    ];
  };

  flake.modules.homeManager.ssh = {
    programs.ssh = {
      settings = {
        "*" = {
          addKeysToAgent = "yes";
          setEnv = ["TERM=xterm-256color"];
        };
        "*fenix*.local oclea*.local Oclea*.local zeus*.local hercules*.local depth-rdk*.local" = {
          UserKnownHostsFile = "/dev/null";
          User = "root";
          LogLevel = "QUIET";
          StrictHostKeyChecking = "no";
        };
        "deskpi" = {
          User = "pi";
          Hostname = "deskpi.local";
        };
        "ats*" = {
          User = "pi";
        };
        "ats1" = {
          Hostname = "10.71.7.75";
        };
        "ats2" = {
          Hostname = "10.71.6.220";
        };
        "ats3" = {
          Hostname = "10.71.5.97";
        };
        "cv2" = {
          User = "pi";
          Hostname = "10.71.5.219";
        };
        "mikyla" = {
          User = "mikyla";
          Hostname = "10.71.0.125";
        };
      };
    };
  };
}
