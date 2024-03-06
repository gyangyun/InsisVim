-- place this in one of your configuration file(s)
local text_case = pRequire("textcase")
local cfg = require("insis").config.text_case

if text_case and cfg and cfg.enable then
  text_case.setup({})
  require("telescope").load_extension("textcase")
  vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
  vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
  vim.api.nvim_set_keymap("n", "gaa", "<cmd>TextCaseOpenTelescopeQuickChange<CR>", { desc = "Telescope Quick Change" })
  vim.api.nvim_set_keymap("n", "gai", "<cmd>TextCaseOpenTelescopeLSPChange<CR>", { desc = "Telescope LSP Change" })

  vim.api.nvim_set_keymap(
    "n",
    "gau",
    ":lua require('textcase').current_word('to_upper_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gal",
    ":lua require('textcase').current_word('to_lower_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gas",
    ":lua require('textcase').current_word('to_snake_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gad",
    ":lua require('textcase').current_word('to_dash_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gan",
    ":lua require('textcase').current_word('to_constant_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gad",
    ":lua require('textcase').current_word('to_dot_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gaa",
    ":lua require('textcase').current_word('to_phrase_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gac",
    ":lua require('textcase').current_word('to_camel_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gap",
    ":lua require('textcase').current_word('to_pascal_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gat",
    ":lua require('textcase').current_word('to_title_case')<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gaf",
    ":lua require('textcase').current_word('to_path_case')<CR>",
    { noremap = true, silent = true }
  )
end
