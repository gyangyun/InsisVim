-- For common keybindings -------------------------------

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
---------------------------------------------------------

local cfg = require("insis").config
local keys = cfg.keys
if not keys then
  return
end

-- leader key
vim.g.mapleader = keys.leader_key
vim.g.maplocalleader = keys.leader_key

-- save && quit
keymap("n", keys.n_save, "<CMD>w<CR>")
keymap("n", keys.n_force_quit, "<CMD>qa!<CR>")
-- keymap("n", keys.n_save_quit, "<CMD>wq<CR>")
-- keymap("n", keys.n_save_all, "<CMD>wa<CR>")
-- keymap("n", keys.n_save_all_quit, "<CMD>wqa<CR>")

-- $ jump to the end without space (swap $ and g_)
-- keymap({ "v", "n" }, "$", "g_")
-- keymap({ "v", "n" }, "g_", "$")

keymap({ "n", "v" }, keys.n_v_5j, "5j")
keymap({ "n", "v" }, keys.n_v_5k, "5k")

keymap({ "n", "v" }, keys.n_v_10j, "10j")
keymap({ "n", "v" }, keys.n_v_10k, "10k")

-- very magic search mode
if cfg.enable_very_magic_search then
  keymap({ "n", "v" }, "/", "/\\v", {
    remap = false,
    silent = false,
  })
  keymap("c", "%s/", "%s/\\v", {
    remap = false,
    silent = false,
  })
end

-------------------- fix ------------------------------

local opts_expr = {
  expr = true,
  silent = true,
}
-- fix :set wrap
keymap({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", opts_expr)
keymap({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", opts_expr)

-- Visual shifting，移动后移到Visual Block的结束处，而不是默认的Visual Block的结束处。但是这样不方便配合"."重复移动操作，不喜欢用
-- keymap("v", "<", "<gv")
-- keymap("v", ">", ">gv")

-- Allow using the repeat operator with a visual selection (!)
keymap("v", ".", ":normal .<CR>")

-- 上下移动选中文本
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")

-- 在visual mode 里粘贴不要复制
-- keymap("x", "p", '"_dP')

-- 切换折叠
keymap("n", "+", "za")
keymap("n", "-", "za")

-- Code folding options
keymap("n", "<leader>z0", ":set foldlevel=0<CR>")
keymap("n", "<leader>z1", ":set foldlevel=1<CR>")
keymap("n", "<leader>z2", ":set foldlevel=2<CR>")
keymap("n", "<leader>z3", ":set foldlevel=3<CR>")
keymap("n", "<leader>z4", ":set foldlevel=4<CR>")
keymap("n", "<leader>z5", ":set foldlevel=5<CR>")
keymap("n", "<leader>z6", ":set foldlevel=6<CR>")
keymap("n", "<leader>z7", ":set foldlevel=7<CR>")
keymap("n", "<leader>z8", ":set foldlevel=8<CR>")
keymap("n", "<leader>z9", ":set foldlevel=9<CR>")

-- fold-manual 手动建立折叠。
-- fold-indent 相同缩进距离的行构成折叠。
-- fold-expr 'foldexpr' 给出每行的折叠级别。
-- fold-marker 标志用于指定折叠。
-- fold-syntax 语法高亮项目指定折叠。
-- fold-diff 没有改变的文本构成折叠。
keymap("n", "<leader>zi", ":set sw=4 ts=4 sts=4 et tw=78 foldlevel=0 foldmethod=indent<CR>")
keymap("n", "<leader>ze", ":set sw=4 ts=4 sts=4 et tw=78 foldlevel=0 foldmethod=expr<CR>")
keymap("n", "<leader>zm", ":set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker<CR>")
keymap("n", "<leader>zs", ":set sw=4 ts=4 sts=4 et tw=78 foldlevel=0 foldmethod=syntax<CR>")
keymap("n", "<leader>zd", ":set sw=4 ts=4 sts=4 et tw=78 foldlevel=0 foldmethod=diff<CR>")

-- 快速编辑一个文档
vim.api.nvim_command("cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>")
vim.api.nvim_command("map <leader>ew :e %%")
vim.api.nvim_command("map <leader>es :sp %%")
vim.api.nvim_command("map <leader>ev :vsp %%")
vim.api.nvim_command("map <leader>et :tabe %%")

-- 快速复制一行
keymap("n", "Y", "y$")

-- 清除行首空格
keymap("n", "cH", [[:%s/^\s\+//g<CR>:noh<CR>]])

-- 清除行尾空格
keymap("n", "cL", [[:%s/\s\+$//g<CR>:noh<CR>]])

-- 清除行尾 ^M 符号
keymap("n", "cM", [[:%s/\r$//g<CR>:noh<CR>]])

-- 插入模式下光标向右移动
keymap("i", "<C-f>", "<Right>")
-- 插入模式下光标向左移动
keymap("i", "<C-b>", "<Left>")

-- 快速插入一个空格
keymap("n", "]w", "a<SPACE><ESC>")
-- 快速插入一个空格
keymap("n", "[w", "i<SPACE><ESC>")

-- 下方快速插入一个空行
keymap("n", "]<SPACE>", [[:call append(line('.'), '')<CR>]])
-- 上方快速插入一个空行
keymap("n", "[<SPACE>", [[:call append(line('.')-1, '')<CR>]])

-- 先排序后去重
keymap("n", "<leader>dd", [[:sort<CR>:%!uniq<CR>]])

function pretty_json()
  -- 需要lua先安装dkjson模块：luarocks install dkjson
  -- 如果没有lua包管理器luarocks，先安装luarocks：brew install luarocks
  local json = require("dkjson")

  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local str = table.concat(content, "\n")
  local decoded, _, err = json.decode(str, 1, nil)
  if err then
    print("Error decoding JSON: " .. err)
    return
  end
  local pretty = json.encode(decoded, { indent = true })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(pretty, "\n"))
end

-- 对json内容进行美化
keymap("n", "<leader>jt", ":lua pretty_json()<CR>")

keymap("v", "<leader>en", [[:!echo -n % | xxd -p | tr -d '\n' | sed 's/\(..\)/%\1/g' | xxd -r -p<CR>]])
keymap("v", "<leader>de", [[:!echo -n % | sed 's/%%/\n/g' | xxd -r -p<CR>]])

-- 针对markdown文件，将代码块中的语言标记为python
keymap("n", "<leader>`p", [[:%s/^```\(\_.\{-\}\)```/```python\1```/g<CR>:noh<CR>]])
-- 针对markdown文件，将ex风格转换成Atx风格
keymap("n", "<leader>s2a", [[:SetexToAtx<CR>]])

function url_decode(str)
  -- 这句可能把真的加号替换了
  -- str = str:gsub("+", " ")
  str = str:gsub("%%(%x%x)", function(h)
    return string.char(tonumber(h, 16))
  end)
  return str
end

function decode_url_in_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = url_decode(line)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

-- 针对markdown文件，将url编码转换成普通字符
keymap("n", "<leader>ud", ":lua decode_url_in_buffer()<CR>")

-- 删除markdown文件中的外链接
-- 注意这里用了两个tricks：
-- 1. lua语法中双引号中不能使用"\"，所以待执行语句用[[xxxx]]，而不是"xxxx"
-- 2. 这里使用"[^:]"而不是"."，因为"."会匹配到":"，如果连续两个外链接写在一行，会导致贪婪匹配，从第一个外链接匹配到第二个外链接
keymap("n", "<leader>dl", [[:%s/https\?:[^:]\{-\}\(to\|target\)=//g<CR>:noh<CR>]])

-- 将markdown文件中的图片+链接转换为图片
-- "[![](https://oss.imzhanghao.com/img/20210526143504.png)](https://oss.imzhanghao.com/img/20210526143504.png "Encoder-Decoder框架")“
-- 提取成:
-- "![](https://oss.imzhanghao.com/img/20210526143504.png)"
keymap("n", "<leader>dp", [[%s/\[\(\!\[\]([^)]*)\)\]([^)]*)/\1/g<CR>:noh<CR>]])

function rename_and_reload(new_filename)
  local old_name = vim.fn.expand("%:p")
  local new_name = vim.fn.expand("%:p:h") .. "/" .. new_filename
  local bufnr = vim.api.nvim_get_current_buf()

  vim.cmd("saveas " .. new_name)
  os.remove(old_name)
  vim.cmd("edit " .. new_name)
  vim.api.nvim_buf_delete(bufnr, { force = true })
end
-- 将 HTML 转换为 Markdown 的函数绑定到 Neovim 命令中
keymap("n", "<leader>rr", ":lua rename_and_reload(vim.fn.input('New filename: '))<CR>")
--------------- super window -----------------------

if cfg.s_windows ~= nil and cfg.s_windows.enable then
  local skey = cfg.s_windows.keys
  -- 以下配置会导致s模式失效
  -- keymap("n", "s", "")
  keymap("n", skey.split_vertically, ":vsp<CR>")
  keymap("n", skey.split_horizontally, ":sp<CR>")
  keymap("n", skey.close, "<C-w>c") -- close current
  keymap("n", skey.close_others, "<C-w>o") -- close others
  keymap("n", skey.jump_left, "<C-w>h")
  keymap("n", skey.jump_down, "<C-w>j")
  keymap("n", skey.jump_up, "<C-w>k")
  keymap("n", skey.jump_right, "<C-w>l")
  keymap("n", skey.width_decrease, ":vertical resize -10<CR>")
  keymap("n", skey.width_increase, ":vertical resize +10<CR>")
  keymap("n", skey.height_decrease, ":horizontal resize -10<CR>")
  keymap("n", skey.height_increase, ":horizontal resize +10<CR>")
  keymap("n", skey.size_equal, "<C-w>=")
end

--------------- toggleterm -----------------------
-- toggleterm最好是和super window共用同一套快捷键，所以写在这里
function _G.set_terminal_keymaps()
  local skey = cfg.s_windows.keys
  keymap("t", keys.back_to_normal, [[<C-\><C-n>]])
  keymap("t", keys.back_to_window, [[<C-\><C-n><C-w>]])
  keymap("t", skey.jump_left, [[<Cmd>wincmd h<CR>]])
  keymap("t", skey.jump_down, [[<Cmd>wincmd j<CR>]])
  keymap("t", skey.jump_up, [[<Cmd>wincmd k<CR>]])
  keymap("t", skey.jump_right, [[<Cmd>wincmd l<CR>]])
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Esc back to Normal mode
keymap("i", keys.back_to_normal, [[<C-\><C-n>]])
-------------- super tab ---------------------------

if cfg.s_tab ~= nil and cfg.s_tab.enable then
  local tkey = cfg.s_tab.keys
  keymap("n", tkey.split, "<CMD>tab split<CR>")
  keymap("n", tkey.close, "<CMD>tabclose<CR>")
  keymap("n", tkey.next, "<CMD>tabnext<CR>")
  keymap("n", tkey.prev, "<CMD>tabprev<CR>")
  keymap("n", tkey.first, "<CMD>tabfirst<CR>")
  keymap("n", tkey.last, "<CMD>tablast<CR>")
end

-- treesitter fold
keymap("n", keys.fold.open, ":foldopen<CR>")
keymap("n", keys.fold.close, ":foldclose<CR>")

-- Esc back to Normal mode
keymap("t", keys.terminal_to_normal, "<C-\\><C-n>")

-- DEPRECATED :Terminal kes

-- map("n", "st", ":sp | terminal<CR>", opt)
-- map("n", "stv", ":vsp | terminal<CR>", opt)
-- map("t", "<A-h>", [[ <C-\><C-N><C-w>h ]], opt)
-- map("t", "<A-j>", [[ <C-\><C-N><C-w>j ]], opt)
-- map("t", "<A-k>", [[ <C-\><C-N><C-w>k ]], opt)
-- map("t", "<A-l>", [[ <C-\><C-N><C-w>l ]], opt)
-- map("t", "<leader>h", [[ <C-\><C-N><C-w>h ]], opt)
-- map("t", "<leader>j", [[ <C-\><C-N><C-w>j ]], opt)
-- map("t", "<leader>k", [[ <C-\><C-N><C-w>k ]], opt)
-- map("t", "<leader>l", [[ <C-\><C-N><C-w>l ]], opt)
