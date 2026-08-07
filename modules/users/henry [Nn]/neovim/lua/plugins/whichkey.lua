require("which-key").setup({
  preset = "helix",
  delay = function(ctx)
    if ctx.keys:match("^<Space>") then
      return 0
    end
    return ctx.plugin and 0 or 200
  end,
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
