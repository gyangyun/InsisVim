vim.g.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "ucs-bom", "cp936", "gb18030", "big5", "gb2312", "euc-jp", "euc-kr", "latin1" }

-- jkhl padding
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- use relative number
vim.wo.number = true
vim.wo.relativenumber = true
-- highlight current row /column
vim.wo.cursorline = true
vim.wo.cursorcolumn = false
-- left sign column
vim.wo.signcolumn = "yes"
-- line of reference on right
-- vim.wo.colorcolumn = "80"
-- 2 space = 1 tab
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
-- >> << move
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
-- space instead tab
vim.o.expandtab = true
vim.bo.expandtab = true
-- copy indent from current line when starting a new line
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- ignore case except uppercase
vim.o.ignorecase = true
vim.o.smartcase = true
-- search hight
vim.opt.hlsearch = false
vim.o.incsearch = true
vim.o.cmdheight = 1
-- auto load when file edit outside
vim.o.autoread = true
vim.bo.autoread = true
-- no wrap for code
vim.wo.wrap = true
vim.o.whichwrap = "<,>,[,]"
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 500
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.o.timeoutlen = 500
-- split window right and below
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.opt.termguicolors = true
-- invisible chars display
vim.o.list = false
vim.o.listchars = "space:·,tab:··"
-- cmp
vim.g.completeopt = "menu,menuone,noselect,noinsert"
--command-line completion is enhanced
vim.o.wildmenu = true
-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. "c"
-- popup menu 10 items in max
vim.o.pumheight = 10
-- always display tabline
vim.o.showtabline = 2
-- use lualine plugin instead
vim.o.showmode = false
-- system clipboard
vim.opt.clipboard = "unnamedplus"
-- disable netrw at the very start of your init.lua (strongly advised) nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.backup = true
vim.o.swapfile = true
vim.o.undofile = true

vim.o.undolevels = 1000
vim.o.undoreload = 10000

local function initialize_directories()
  -- views/backup/swap/undo等文件默认存放在临时目录——"~/.local/state/nvim中"
  -- 可能会被清理，更换存放位置
  local common_dir = vim.fn.stdpath("data")

  local dir_list = {
    views = "viewdir",
  }

  if vim.o.backup then
    dir_list["backup"] = "backupdir"
  end
  if vim.o.swapfile then
    dir_list["swap"] = "directory"
  end
  if vim.o.undofile then
    dir_list["undo"] = "undodir"
  end

  for dirname, settingname in pairs(dir_list) do
    local directory = common_dir .. "/" .. dirname .. "/"
    if vim.fn.mkdir(directory, "p") == 0 then
      local errormsg = "Warning: Unable to create directory: " .. directory
      errormsg = errormsg .. "\nTry: mkdir -p " .. directory
      vim.api.nvim_err_writeln(errormsg)
    else
      directory = vim.fn.substitute(directory, " ", "\\ ", "g")
      vim.cmd("set " .. settingname .. "=" .. directory)
    end
  end
end
initialize_directories()

-- local sysname = vim.loop.os_uname().sysname
-- if sysname == "Windows_NT" then
--     -- Windows特定的配置
--     print("这是Windows系统")
-- elseif sysname == "Linux" then
--     -- Linux特定的配置
--     print("这是Linux系统")
-- elseif sysname == "Darwin" then
--     -- macOS特定的配置
--     print("这是macOS系统")
-- end

local is_wsl = false
local handle = io.popen("uname -r")
local result = handle:read("*a")
handle:close()

if result:find("Microsoft") or result:find("WSL") then
  is_wsl = true
end

if is_wsl then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end
