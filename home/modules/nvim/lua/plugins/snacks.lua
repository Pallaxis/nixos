require("snacks").setup({
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
      buffers = {
        focus = "list",
      },
    },
  },
})
-- Search
vim.keymap.set("n", "<leader>sr", function()
  Snacks.picker.registers()
end, { desc = "[S]earch [r]egisters" })
vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.buffers()
end, { desc = "[S]earch [b]uffers" })
vim.keymap.set("n", "<leader>sh", function()
  Snacks.picker.command_history()
end, { desc = "[S]earch [h]istory (command)" })
vim.keymap.set("n", "<leader>sH", function()
  Snacks.picker.search_history()
end, { desc = "[S]earch [H]istory (search)" })
vim.keymap.set("n", "<leader>sm", function()
  Snacks.picker.marks()
end, { desc = "[S]earch [m]arks" })
vim.keymap.set("n", "<leader>sM", function()
  Snacks.picker.man()
end, { desc = "[S]earch [M]an pages" })
vim.keymap.set("n", "<leader>su", function()
  Snacks.picker.undo()
end, { desc = "[S]earch [u]ndo history" })
vim.keymap.set("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "[S]earch [k]eymaps" })
vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "[S]earch [g]rep" })
vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.files()
end, { desc = "[S]earch [f]iles" })
vim.keymap.set("n", "<leader>se", function()
  Snacks.explorer.open()
end, { desc = "[S]earch [e]xplorer" })
-- Git
vim.keymap.set("n", "<leader>gd", function()
  Snacks.picker.git_diff()
end, { desc = "[G]it [d]iff" })
vim.keymap.set("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "[G]it [s]tatus" })
vim.keymap.set("n", "<leader>gl", function()
  Snacks.picker.git_log()
end, { desc = "[G]it [l]og" })
vim.keymap.set("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "[G]it log of [f]ile" })
vim.keymap.set("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end, { desc = "[G]it [b]ranches" })
-- LSP
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[G]oto [r]e[n]ame" })
vim.keymap.set("n", "grd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "[G]oto [d]efinition" })
vim.keymap.set("n", "grD", function()
  Snacks.picker.lsp_declarations()
end, { desc = "[G]oto [D]eclaration" })
vim.keymap.set("n", "grr", function()
  Snacks.picker.lsp_references()
end, { desc = "[G]oto [r]eferences" })
vim.keymap.set("n", "grt", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "[G]oto [t]ype definition" })
vim.keymap.set("n", "gai", function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = "[G]oto C[a]lls [i]ncoming" })
vim.keymap.set("n", "gao", function()
  Snacks.picker.lsp_outgoing_calls()
end, { desc = "[G]oto C[a]lls [o]utgoing" })
