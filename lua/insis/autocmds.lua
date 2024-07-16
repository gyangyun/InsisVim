local cfg = require("insis").config
local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

if cfg.enable_imselect then
  autocmd("InsertLeave", {
    group = myAutoGroup,
    callback = require("insis.utils.im-select").insertLeave,
  })

  autocmd("InsertEnter", {
    group = myAutoGroup,
    callback = require("insis.utils.im-select").insertEnter,
  })
end

-- auto insert mode when TermOpen
autocmd("TermOpen", {
  group = myAutoGroup,
  command = "startinsert",
})

-- format on save
autocmd("BufWritePre", {
  group = myAutoGroup,
  pattern = require("insis.env").getFormatOnSavePattern(),
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- set *.mdx to filetype to markdown
autocmd({ "BufNewFile", "BufRead" }, {
  group = myAutoGroup,
  pattern = "*.mdx",
  command = "setfiletype markdown",
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = myAutoGroup,
  pattern = "*.html.twig",
  command = "set filetype=html.twig",
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = myAutoGroup,
  pattern = "*.coffee",
  command = "set filetype=coffee",
})

-- autocmd({ "BufNewFile", "BufRead" }, {
--   group = myAutoGroup,
--   pattern = "*.txt",
--   command = "set filetype=txt",
-- })

autocmd("FileType", {
  group = myAutoGroup,
  pattern = { "php", "python", "c", "java", "perl", "shell", "bash", "vim", "ruby", "cpp" },
  command = "setlocal ai sw=4 ts=4 sts=4",
})

autocmd("FileType", {
  group = myAutoGroup,
  pattern = { "lua", "javascript", "html", "css", "xml", "vue", "scala" },
  command = "setlocal ai sw=2 ts=2 sts=2",
})

autocmd("FileType", {
  group = myAutoGroup,
  pattern = { "haskell", "puppet", "ruby", "yml" },
  command = "setlocal expandtab shiftwidth=2 softtabstop=2",
})

-- set wrap only in markdown
autocmd("FileType", {
  group = myAutoGroup,
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Remove trailing whitespaces and ^M chars
autocmd({ "FileType", "BufWritePre" }, {
  group = myAutoGroup,
  pattern = {
    "c",
    "cpp",
    "java",
    "go",
    "php",
    "javascript",
    "puppet",
    "python",
    "rust",
    "twig",
    "xml",
    "yml",
    "perl",
    "sql",
  },
  callback = function()
    -- 准备工作：保存上一次的搜索以及光标位置
    local last_search = vim.fn.getreg("/")
    local cursor_pos = vim.fn.getcurpos()

    -- 执行操作：删除行尾的空白字符
    vim.cmd("%s/\\s\\+$//e")
    -- 执行操作：删除行尾的^M字符
    vim.cmd("%s/\\r$//e")

    -- 清理工作：恢复上一次的搜索和光标位置
    vim.fn.setreg("/", last_search)
    vim.fn.setpos(".", cursor_pos)
  end,
})

-- auto run PackerSync when pluginlist is modified
autocmd("BufWritePost", {
  group = myAutoGroup,
  -- autocmd BufWritePost plugins.lua source <afile> | PackerSync
  callback = function()
    if vim.fn.expand("<afile>") == "lua/insis/plugins/init.lua" then
      vim.api.nvim_command("source lua/insis/plugins/init.lua")
      require("insis.packer").setup()
      vim.api.nvim_command("PackerSync")
    end
  end,
})

-- highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = myAutoGroup,
  pattern = "*",
})

-- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    vim.opt.hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

-- do not continue comments when type o
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "o" -- O and o, don't continue comments
      + "r" -- But do continue when pressing enter.
  end,
})

autocmd({ "FileType" }, {
  group = myAutoGroup,
  pattern = {
    "help",
    "man",
    "neotest-output",
  },
  callback = function()
    keymap({ "i", "n" }, { "q", "<esc>" }, "<esc>:close<CR>", { buffer = true })
  end,
})

-- 增加python的快捷键，方便调试
autocmd({ "FileType" }, {
  group = myAutoGroup,
  pattern = { "python" },
  callback = function()
    keymap("n", "<leader>B", "Ofrom IPython import embed;embed()<Esc>")
  end,
})

-- save fold
autocmd("BufWinEnter", {
  group = myAutoGroup,
  pattern = "*",
  command = "silent! loadview",
})

autocmd("BufWrite", {
  group = myAutoGroup,
  pattern = "*",
  command = "mkview",
})

-- automatically switch to the current file directory when a new buffer is opened
autocmd({ "BufEnter" }, {
  group = myAutoGroup,
  pattern = "*",
  -- command = "lcd %:p:h",
  -- coc-python的python.execInTerminal等方法，会打开一个buffer来运行Terminal，名字为'!/bin/zsh'，%:p:h就是'!/bin'，这个不需要切换，否则会报错：E344: Can't find directory '!/bin' in cdpath
  callback = function()
    if not string.match(vim.fn.bufname(""), "^!") and not string.match(vim.fn.bufname(""), "^[A-Za-z0-9]*://") then
      vim.cmd("lcd %:p:h")
    end
  end,
})
