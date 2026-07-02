{pkgs, ...}: {
  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua".source = ./lua;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    waylandSupport = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      conform-nvim
      which-key-nvim
      # # navigator-nvim
      smart-splits-nvim
      nvim-lint
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.diff
        p.gitcommit
        p.gitignore
        p.git_rebase
        p.javascript
        p.lua
        p.luadoc
        p.markdown
        p.markdown_inline
        p.nix
        p.python
        p.qmljs
        p.vim
        p.vimdoc
      ]))
      gitsigns-nvim
      render-markdown-nvim
      snacks-nvim
      nvim-lspconfig
      luasnip
      blink-cmp
      diffview-nvim
      nvim-web-devicons
    ];
    extraPackages = with pkgs; [
      alejandra # nix formatter
      kdePackages.qtdeclarative # qml formatter
      statix # nix linter
      nixd # nix ls
      stylua # lua formatter
      basedpyright # python ls
      hyprls # hypr ls
      shellcheck-minimal # bash ls
      luajitPackages.jsregexp # for luasnip
      ripgrep
    ];
  };
}
