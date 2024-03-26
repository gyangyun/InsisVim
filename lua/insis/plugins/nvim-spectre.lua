local spectre = pRequire("spectre")
local cfg = require("insis").config.spectre

if spectre and cfg and cfg.enable then
  keymap("n", cfg.keys.toggle, '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre",
  })
  keymap("n", cfg.keys.search_word, '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word",
  })
  keymap("v", cfg.keys.search_visual, '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search visual word",
  })
  keymap("n", cfg.keys.search_file, '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search current word on current file",
  })

  -- 在Spectre窗口中
  -- ?：查看所有按键
  -- <leader>R：替换所有
  -- <leader>rc：替换当前光标所在行的匹配项
  -- <cr>：跳到该匹配项的原文件位置
  -- <leader>q：将所有匹配项发送到quickfix中
end
