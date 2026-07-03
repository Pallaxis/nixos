require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>gh", gitsigns.preview_hunk, { desc = "[g]it [h]unk" })
    map("n", "<leader>gB", gitsigns.blame, { desc = "[g]it [B]lame" })
    map("n", "<leader>gn", function()
      gitsigns.nav_hunk("next")
    end, { desc = "[g]it [n]ext hunk" })
    map("n", "<leader>gp", function()
      gitsigns.nav_hunk("prev")
    end, { desc = "[g]it [p]rev hunk" })
  end,
})
