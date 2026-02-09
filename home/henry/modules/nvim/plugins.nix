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
          pattern = { 'nix' },
          callback = function() vim.treesitter.start() end,
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
      plugin = pkgs.vimPlugins.snacks-nvim;
      type = "lua";
      config = ''
        require('snacks').setup({
          explorer = {
            enabled = true,
            replace_netrw = true,
          },
          picker = {
            enabled = true,
            sources = {
              explorer = {
                layout = {
                  preset = "default",
                },
              },
            },
          },
        })
        -- Search
          vim.keymap.set('n', 'sr', function() Snacks.picker.registers() end, { desc = '[S]earch registers' })
          vim.keymap.set('n', 's/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
          vim.keymap.set('n', 'sM', function() Snacks.picker.man() end, { desc = 'Man pages' })
          vim.keymap.set('n', 'su', function() Snacks.picker.undo() end, { desc = 'Undo History' })
          vim.keymap.set('n', 'sk', function() Snacks.picker.keymaps() end, { desc = 'Search Keymaps' })
          vim.keymap.set('n', 'sf', function() Snacks.explorer.open() end, { desc = '[S]earch [F]iles' })
        -- LSP
          vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
          vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = '[G]oto [d]efinition' })
          vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = '[G]oto [D]eclaration' })
          vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = '[G]oto [r]eferences' })
          vim.keymap.set('n', 'gt', function() Snacks.picker.lsp_type_definitions() end, { desc = '[G]oto [t]ype definition' })
          vim.keymap.set('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { desc = '[G]oto C[a]lls [i]ncoming' })
          vim.keymap.set('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { desc = '[G]oto C[a]lls [o]utgoing' })
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

        --  vim.api.nvim_create_autocmd('LspAttach', {
        --    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        --    callback = function(event)
        --      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        --      -- to define small helper and utility functions so you don't have to repeat yourself.
        --      --
        --      -- In this case, we create a function that lets us more easily define mappings specific
        --      -- for LSP related items. It sets the mode, buffer and description for us each time.
        --      local map = function(keys, func, desc, mode)
        --        mode = mode or 'n'
        --        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        --      end
        --
        --      -- Rename the variable under your cursor.
        --      --  Most Language Servers support renaming across files, etc.
        --      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        --
        --      -- Execute a code action, usually your cursor needs to be on top of an error
        --      -- or a suggestion from your LSP for this to activate.
        --      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        --
        --      -- Find references for the word under your cursor.
        --      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        --
        --      -- Jump to the implementation of the word under your cursor.
        --      --  Useful when your language has ways of declaring types without an actual implementation.
        --      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        --
        --      -- Jump to the definition of the word under your cursor.
        --      --  This is where a variable was first declared, or where a function is defined, etc.
        --      --  To jump back, press <C-t>.
        --      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        --
        --      -- WARN: This is not Goto Definition, this is Goto Declaration.
        --      --  For example, in C this would take you to the header.
        --      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        --
        --      -- Fuzzy find all the symbols in your current document.
        --      --  Symbols are things like variables, functions, types, etc.
        --      map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        --
        --      -- Fuzzy find all the symbols in your current workspace.
        --      --  Similar to document symbols, except searches over your entire project.
        --      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        --
        --      -- Jump to the type of the word under your cursor.
        --      --  Useful when you're not sure what type a variable is and you want to see
        --      --  the definition of its *type*, not where it was *defined*.
        --      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        --
        --      -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        --      ---@param client vim.lsp.Client
        --      ---@param method vim.lsp.protocol.Method
        --      ---@param bufnr? integer some lsp support methods only in specific files
        --      ---@return boolean
        --      local function client_supports_method(client, method, bufnr)
        --        if vim.fn.has 'nvim-0.11' == 1 then
        --          return client:supports_method(method, bufnr)
        --        else
        --          return client.supports_method(method, { bufnr = bufnr })
        --        end
        --      end
        --
        --      -- The following two autocommands are used to highlight references of the
        --      -- word under your cursor when your cursor rests there for a little while.
        --      --    See `:help CursorHold` for information about when this is executed
        --      --
        --      -- When you move your cursor, the highlights will be cleared (the second autocommand).
        --      local client = vim.lsp.get_client_by_id(event.data.client_id)
        --      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        --        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        --        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        --          buffer = event.buf,
        --          group = highlight_augroup,
        --          callback = vim.lsp.buf.document_highlight,
        --        })
        --
        --        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        --          buffer = event.buf,
        --          group = highlight_augroup,
        --          callback = vim.lsp.buf.clear_references,
        --        })
        --
        --        vim.api.nvim_create_autocmd('LspDetach', {
        --          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        --          callback = function(event2)
        --            vim.lsp.buf.clear_references()
        --            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        --          end,
        --        })
        --      end
        --
        --     -- The following code creates a keymap to toggle inlay hints in your
        --     -- code, if the language server you are using supports them
        --     --
        --     -- This may be unwanted, since they displace some of your code
        --     if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        --       map('<leader>th', function()
        --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        --       end, '[T]oggle Inlay [H]ints')
        --     end
        --
        --     map('<leader>td', function()
        --       vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        --     end, '[T]oggle [D]iagnostics')
        --   end,
        -- })

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
