vim.filetype.add({
  extension = {
    dump = "vim",
  },
})
-- Starts Treesitter if parser for filetype is installed
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    if not vim.treesitter.language.add(language) then
      return
    end

    vim.treesitter.start(buf, language)
  end,
})
