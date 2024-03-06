local nvimMarkdown = pRequire("nvim-markdown")
local cfg = require("insis").config.markdown

if nvimMarkdown and cfg and cfg.enable then
  -- 禁用标题折叠
  vim.g.vim_markdown_folding_disabled = 1

  -- 不使用conceal功能，因实现不佳
  -- Nothing is concealed
  vim.g.vim_markdown_conceal = 0
  -- " Links are concealed
  -- vim.g.vim_markdown_conceal = 1
  -- " Links and text formatting is concealed (default)
  -- vim.g.vim_markdown_conceal = 2

  -- To disable math conceal with LaTeX math syntax enabled
  vim.g.tex_conceal = ""
  vim.g.vim_markdown_math = 1

  -- 支持多种格式的前置内容（Front matter）
  vim.g.vim_markdown_frontmatter = 1 -- 对于YAML格式
  vim.g.vim_markdown_toml_frontmatter = 1 -- 对于TOML格式
  vim.g.vim_markdown_json_frontmatter = 1 -- 对于JSON格式
end
