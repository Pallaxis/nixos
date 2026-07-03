path = vim.fn.stdpath("config") .. "/lua/plugins"

for name, _ in vim.fs.dir(path) do
  if name ~= "init.lua" then
    plugin = string.gsub(name, "%.lua$", "")
    plugin_path = "plugins." .. plugin
    require(plugin_path)
  end
end
