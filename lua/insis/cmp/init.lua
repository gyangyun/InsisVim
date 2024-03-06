local cmp = pRequire("cmp")
local luasnip = pRequire("luasnip")
local cfg = require("insis").config.cmp

if not cmp or not luasnip or not cfg or not cfg.enable then
  return
end

local formatting = require("insis.cmp.format").formatting

-- 不像其他的补全源，copilot可能在前面或者后面行为空白的情况下提供补全内容，比如注释行下面
-- 这将导致insert mode想使用<Tab>输入制表符时反而进行了补全，因此copilot重新实现了has_words_before方法和[<Tab>]映射
-- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local mapping = {
  [cfg.keys.complete] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  [cfg.keys.abort] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  -- Accept currently selected item. If none selected, `select` first item.
  -- Set `select` to `false` to only confirm explicitly selected items.
  [cfg.keys.confirm] = cmp.mapping.confirm({
    select = false,
    behavior = cmp.ConfirmBehavior.Replace,
  }),
  [cfg.keys.scroll_doc_up] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
  [cfg.keys.scroll_doc_down] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
  [cfg.keys.select_prev_item] = cmp.mapping.select_prev_item(),
  [cfg.keys.select_next_item] = cmp.mapping.select_next_item(),
  -- super-tab-like mapping
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
  -- ["<Tab>"] = cmp.mapping(function(fallback)
  --   if cmp.visible() then
  --     cmp.select_next_item()
  --   -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
  --   -- they way you will only jump inside the snippet region
  --   elseif luasnip.expand_or_locally_jumpable() then
  --     -- elseif luasnip.expand_or_jumpable() then
  --     luasnip.expand_or_jump()
  --   elseif has_words_before() then
  --     cmp.complete()
  --   else
  --     fallback()
  --   end
  -- end, { "i", "s" }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      -- cmp.confirm和上面的区别是如果摁Tab自动选择第一个补全项，不用再摁回车确认，这当然不是我们的目的，我们的目的使用Tab来遍历补全项
      -- cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

-- select next/prev in command mode
keymap("c", cfg.keys.select_next_item, "<C-n>", {
  remap = true,
  silent = true,
})
keymap("c", cfg.keys.select_prev_item, "<C-p>", {
  remap = true,
  silent = true,
})

cmp.setup({
  -- we use luasnip
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = mapping,
  formatting = formatting,
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      group_index = 1,
      priority = 1000,
    },
    {
      name = "nvim_lsp_signature_help",
      group_index = 1,
      priority = 1000,
    },
    {
      name = "luasnip",
      group_index = 2,
      priority = 1000,
    },
    {
      name = "copilot",
      group_index = 2,
      priority = 750,
    },
    {
      name = "buffer",
      group_index = 3,
      priority = 500,
    },
    {
      name = "path",
      group_index = 3,
      priority = 300,
    },
  }),
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { {
    name = "buffer",
  } },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ {
    name = "path",
  } }, { {
    name = "cmdline",
  } }),
})

cmp.setup.filetype({ "markdown", "help" }, {
  window = {
    documentation = cmp.config.disable,
  },
  sources = { {
    name = "luasnip",
  }, {
    name = "buffer",
  }, {
    name = "path",
  } },
})

require("insis.cmp.luasnip")
