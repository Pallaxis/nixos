{pkgs, ...}: {
  imports = [
    ./autocmds.nix
    ./keymaps.nix
    ./options.nix
    ./plugins.nix
    ./snippets.nix
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
      luajitPackages.jsregexp # for luasnip
      ripgrep
    ];
  };
}
