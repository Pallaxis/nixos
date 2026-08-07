{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      settings = {
        devices = {
          # Not a nix device so I'm defining it here
          # all others are defined in their host dir
          iPhone = {
            id = "UBH4QQR-EFVPO6H-TJTENLD-K7PSSAS-34KPRWJ-MNJ2CQY-65H3IN7-4633XAQ";
          };
        };
      };
    };
  };
}
