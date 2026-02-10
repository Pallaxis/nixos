{pkgs, ...}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins.nix
    ./autocmds.nix
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    waylandSupport = true;
    extraPackages = with pkgs; [
      alejandra # nix formatter
      statix # nix linter
      nixd # nix ls
      stylua # lua formatter
      pyright # python ls
      hyprls # hypr ls
      shellcheck-minimal # bash ls
      ripgrep
    ];
  };
}
