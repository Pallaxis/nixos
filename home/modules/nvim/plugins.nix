{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        vim.cmd.colorscheme 'catppuccin-nvim'
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
          formatters = {
            stylua = {
              args = { "--indent-type", "Spaces", "--indent-width", "2", "-" }
            },
          },
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.which-key-nvim;
      type = "lua";
      config = ''
        require("which-key").setup({
        })

        vim.keymap.set("n", "<leader>?", function()
          require("which-key").show({ global = false })
        end, { desc = "Buffer Local Keymaps (which-key)" })
      '';
    }
    {
      plugin = pkgs.vimPlugins.Navigator-nvim.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "dynamotn";
          repo = "Navigator.nvim";
          rev = "master";
          sha256 = "zwZgqgIZNmMUVcGibfWWbyzI9plfEFWVFwT366xGGMg=";
        };
      });
      type = "lua";
      config = ''
        require('Navigator').setup({})
        vim.keymap.set('n', '<C-h>', '<CMD>NavigatorLeft<CR>', { silent = true })
        vim.keymap.set('n', '<C-j>', '<CMD>NavigatorDown<CR>', { silent = true })
        vim.keymap.set('n', '<C-k>', '<CMD>NavigatorUp<CR>', { silent = true })
        vim.keymap.set('n', '<C-l>', '<CMD>NavigatorRight<CR>', { silent = true })
      '';
    }
    # NOTE: disabling until speed of nvim > zellij is as good as Navigator, issue #378
    # will eventually swap to this as Navigator is abandoned
    # {
    #   plugin = pkgs.vimPlugins.smart-splits-nvim;
    #   type = "lua";
    #   config = ''
    #     require('smart-splits').setup({})
    #     vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
    #     vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
    #     vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
    #     vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    #
    #     vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    #     vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    #     vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    #     vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
    #   '';
    # }
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
        p.vim
        p.vimdoc
      ]);
      type = "lua";
      config = ''
        vim.filetype.add({
          extension = {
            dump = "vim",
          },
        })
        -- Starts Treesitter if parser for filetype is installed
        vim.api.nvim_create_autocmd('FileType', {
          callback = function(args)
            local buf, filetype = args.buf, args.match

            local language = vim.treesitter.language.get_lang(filetype)
            if not language then return end

            if not vim.treesitter.language.add(language) then return end

            vim.treesitter.start(buf, language)
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
                auto_close = true,
                layout = {
                  preset = "default",
                },
              },
            },
          },
        })
        -- Search
          vim.keymap.set('n', '<leader>sr', function() Snacks.picker.registers() end, { desc = '[S]earch [r]egisters' })
          vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = '[S]earch [b]uffers' })
          vim.keymap.set('n', '<leader>sh', function() Snacks.picker.command_history() end, { desc = '[S]earch [h]istory (command)' })
          vim.keymap.set('n', '<leader>sH', function() Snacks.picker.search_history() end, { desc = '[S]earch [H]istory (search)' })
          vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = '[S]earch [m]arks' })
          vim.keymap.set('n', '<leader>sM', function() Snacks.picker.man() end, { desc = '[S]earch [M]an pages' })
          vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = '[S]earch [u]ndo history' })
          vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [k]eymaps' })
          vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch [g]rep' })
          vim.keymap.set('n', '<leader>sf', function() Snacks.explorer.open() end, { desc = '[S]earch [f]iles' })
        -- LSP
          vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[G]oto [r]e[n]ame' })
          vim.keymap.set('n', 'grd', function() Snacks.picker.lsp_definitions() end, { desc = '[G]oto [d]efinition' })
          vim.keymap.set('n', 'grD', function() Snacks.picker.lsp_declarations() end, { desc = '[G]oto [D]eclaration' })
          vim.keymap.set('n', 'grr', function() Snacks.picker.lsp_references() end, { desc = '[G]oto [r]eferences' })
          vim.keymap.set('n', 'grt', function() Snacks.picker.lsp_type_definitions() end, { desc = '[G]oto [t]ype definition' })
          vim.keymap.set('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { desc = '[G]oto C[a]lls [i]ncoming' })
          vim.keymap.set('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { desc = '[G]oto C[a]lls [o]utgoing' })
      '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-lspconfig;
      type = "lua";
      config = ''
        local servers = { 'nixd', 'basedpyright', 'yaml-language-server', 'hyprls', 'shellcheck' }
          for _, server in ipairs(servers) do
             vim.lsp.enable(server)
          end
        vim.lsp.config("nixd", {
          cmd = { "nixd" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.thinkpad.options',
                 },
                home_manager = {
                  expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."henry@thinkpad".options',
                },
              },
            },
          },
        })
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
    {
      plugin = pkgs.vimPlugins.luasnip;
      type = "lua";
      config = ''
        local ls = require("luasnip")

        ls.setup({})

        require("luasnip.loaders.from_lua").lazy_load({
          paths = vim.fn.expand("~/.config/nvim/lua/snippets")
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.blink-cmp;
      type = "lua";
      config = ''
        local ls = require("luasnip")

        require("blink.cmp").setup({
          snippets = { preset = "luasnip" },

          sources = {
            default = { "lsp", "path", "buffer", "snippets" },
          },

          keymap = { preset = "default" }
        })
      '';
    }
    {
      plugin = pkgs.vimPlugins.diffview-nvim;
      type = "lua";
      config = ''
      '';
    }
  ];
}
