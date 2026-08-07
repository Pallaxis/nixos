local ls = require("luasnip")

ls.setup({})

require("luasnip.loaders.from_lua").lazy_load({
  paths = vim.fn.expand("~/.config/nvim/lua/snippets"),
})
