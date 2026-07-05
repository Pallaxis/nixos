{pkgs, ...}: {
  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/generated.lua".source = pkgs.writeText "generated.lua" ''
    return {
      hyprland_share = "${pkgs.hyprland}/share",
    }
  '';
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    waylandSupport = true;
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      catppuccin-nvim
      conform-nvim
      diffview-nvim
      gitsigns-nvim
      luasnip
      nvim-lint
      nvim-lspconfig
      nvim-web-devicons
      render-markdown-nvim
      smart-splits-nvim
      snacks-nvim
      vim-fugitive
      which-key-nvim
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
    ];
    extraPackages = with pkgs; [
      alejandra # nix formatter
      kdePackages.qtdeclarative # qml formatter
      statix # nix linter
      nixd # nix ls
      stylua # lua formatter
      lua-language-server # lua ls
      basedpyright # python ls
      hyprls # hypr ls
      shellcheck-minimal # bash ls
      luajitPackages.jsregexp # for luasnip
      ripgrep
    ];
  };
}
