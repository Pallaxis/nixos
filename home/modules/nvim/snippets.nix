{...}: {
  home.file.".config/nvim/lua/snippets/nix.lua".text = ''
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    -- Helper function to repeat the input from a specific index
    local function copy(args)
      return args[1][1]
    end
    local function capitalize(args)
      local str = args[1][1]
      return (str:gsub("^%l", string.upper))
    end


    ls.add_snippets("nix", {

      s("newmod", {
        t("{ "),
        i(1),
        t({ "... }: {", "" }),
        t("  "),
        i(0),
        t({ "", "}" }),
      }),

      s("fullmod", {
        t({ "{", "  config,", "  lib,", "  pkgs,", "  ...", "}: {", "" }),
        i(0),
        t({ "", "}" }),
      }),

      s("togglemod", {
        t({ "{", "  config,", "  lib,", "  pkgs,", "  ...", "}: let", "  cfg = config.my.modules." }),
        i(1, "name"),
        t({ ";", "in {", "  options.my.modules." }),
        f(copy, { 1 }),
        t({ ".enable =", '    lib.mkEnableOption "' }),
        f(capitalize, { 1 }),
        t({ '";', "", "  config = lib.mkIf cfg.enable {", "    " }),
        i(0),
        t({ "", "  };", "}" }),
      }),

    })
  '';
}
