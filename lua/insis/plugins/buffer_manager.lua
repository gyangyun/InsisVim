local buffer_manager = pRequire("buffer_manager")
local cfg = require("insis").config.buffer_manager

if buffer_manager and cfg and cfg.enable then
  buffer_manager.setup({
    select_menu_item_commands = {
      v = {
        key = "<C-v>",
        command = "vsplit",
      },
      h = {
        key = "<C-h>",
        command = "split",
      },
    },
    focus_alternate_buffer = false,
    short_file_names = true,
    short_term_names = true,
    loop_nav = false,
  })

  -- Navigate buffers bypassing the menu
  local bmui = require("buffer_manager.ui")
  local keys = "1234567890"
  for i = 1, #keys do
    local key = keys:sub(i, i)
    keymap("n", string.format("<leader>%s", key), function()
      bmui.nav_file(i)
    end)
  end
  -- Just the menu
  keymap({ "t", "n" }, cfg.keys.toggle, bmui.toggle_quick_menu)
  -- Open menu and search
  keymap({ "t", "n" }, cfg.keys.search, function()
    bmui.toggle_quick_menu()
    -- wait for the menu to open
    vim.defer_fn(function()
      vim.fn.feedkeys("/")
    end, 50)
  end)
  -- Next/Prev
  -- 使用默认的j、k就可以
  -- keymap("n", "<M-j>", bmui.nav_next)
  -- keymap("n", "<M-k>", bmui.nav_prev)

  vim.api.nvim_command([[
    autocmd FileType buffer_manager vnoremap J :m '>+1<CR>gv=gv
    autocmd FileType buffer_manager vnoremap K :m '<-2<CR>gv=gv
  ]])
end
