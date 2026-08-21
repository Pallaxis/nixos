{
  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;

      # opencode evaluates the LAST matching rule; keys serialize
      # alphabetically so the *.config/sops* deny sorts before the sops asks
      settings.permission = let
        pathDenies = {
          "~/.config/sops" = "deny";
          "~/.config/sops/**" = "deny";
          "/home/*/.config/sops" = "deny";
          "/home/*/.config/sops/**" = "deny";
        };
      in {
        bash = {
          "*.config/sops*" = "deny";
          "sops" = "ask";
          "sops *" = "ask";
          "sudo sops" = "ask";
          "sudo sops *" = "ask";
        };

        read = pathDenies;
        grep = pathDenies;
        glob = pathDenies;
        list = pathDenies;

        # /nix/store lives outside every project dir, which would otherwise
        # trigger external-directory prompts on every read
        external_directory = {
          "/nix/store" = "allow";
          "/nix/store/**" = "allow";
        };
      };
    };
  };
}
