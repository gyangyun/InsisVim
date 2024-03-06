local cmp = require("insis").config.cmp
if not cmp then
  return
end

local M = {}
M.copilot = function()
  local copilot = pRequire("copilot")
  if copilot and cmp.copilot then
    -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp. To do so, simply place the following in your copilot.lua config:
    -- require("copilot").setup({
    --   suggestion = { enabled = false },
    --   panel = { enabled = false },
    -- })
    copilot.setup({
      panel = {
        enabled = false,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        python = true,
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 16.x
      server_opts_overrides = {},
    })
  end
end

M.copilot_cmp = function()
  local copilot_cmp = pRequire("copilot_cmp")
  if copilot_cmp and cmp.copilot then
    copilot_cmp.setup()
    keymap("n", cmp.keys.copilot_panel, "<CMD>Copilot panel<CR>")
  end
end

return M
