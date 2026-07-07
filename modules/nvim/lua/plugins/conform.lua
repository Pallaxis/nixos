require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    qml = { "qmlformat" },
  },
  formatters = {
    stylua = {
      args = { "--indent-type", "Spaces", "--indent-width", "2", "-", "--column-width", "200" },
    },
    qmlformat = {
      append_args = { "--indent-width", "2" },
    },
  },
})
