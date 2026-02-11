{...}: {
  home.file.".config/nvim/lua/snippets/nix.lua".text = ''
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

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

    })
  '';
}
