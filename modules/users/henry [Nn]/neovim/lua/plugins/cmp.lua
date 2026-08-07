require("blink.cmp").setup({
  snippets = { preset = "luasnip" },

  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
  },

  keymap = { preset = "default" },
})
