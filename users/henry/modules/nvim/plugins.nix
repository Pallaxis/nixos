{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        vim.cmd.colorscheme 'catppuccin-mocha'
      '';
    }
    {
      plugin = pkgs.vimPlugins.conform-nvim;
      type = "lua";
      config = ''
        require("conform").setup({
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = "fallback",
          },
          formatters_by_ft = {
            lua = { "stylua" },
            nix = { "alejandra" },
          },
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.vim-tmux-navigator;
      type = "lua";
      config = ''
        vim.g.tmux_navigator_no_mappings = 1
        vim.keymap.set('n', '<C-h>', ':<C-U>TmuxNavigateLeft<cr>', { silent = true })
        vim.keymap.set('n', '<C-j>', ':<C-U>TmuxNavigateDown<cr>', { silent = true })
        vim.keymap.set('n', '<C-k>', ':<C-U>TmuxNavigateUp<cr>', { silent = true })
        vim.keymap.set('n', '<C-l>', ':<C-U>TmuxNavigateRight<cr>', { silent = true })
      '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-lint;
      type = "lua";
      config = ''
        require('lint').linters_by_ft = {
          nix = {'statix'},
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.diff
        p.javascript
        p.lua
        p.luadoc
        p.markdown
        p.markdown_inline
        p.nix
        p.python
        p.vim
        p.vimdoc
      ]);
      type = "lua";
      config = ''
        vim.api.nvim_create_autocmd('FileType', {
          callback = function(args)
            -- Check if a treesitter parser exists for this filetype
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype
            local ok, _ = pcall(vim.treesitter.language.add, lang)

            if ok then
              vim.treesitter.start()
            end
          end,
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.gitsigns-nvim;
      type = "lua";
      config = ''
        require('gitsigns').setup {
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          }
        }
      '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-lspconfig;
      type = "lua";
      config = ''
        local servers = { 'nixd', 'pyright', 'yaml-language-server', 'hyprls', 'shellcheck' }
          for _, server in ipairs(servers) do
             vim.lsp.enable(server)
          end
        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = 'rounded', source = 'if_many' },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ',
              [vim.diagnostic.severity.WARN] = '󰀪 ',
              [vim.diagnostic.severity.INFO] = '󰋽 ',
              [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
          } or {},
          virtual_text = {
            source = 'if_many',
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }
      '';
    }
  ];
}
