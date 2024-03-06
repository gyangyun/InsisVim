local common = require("insis.lsp.common-config")
local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(client, bufnr)
    common.disableFormat(client)
    common.keyAttach(bufnr)
  end,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391" },
          maxLineLength = 100,
        },
        rope_autoimport = {
          enabled = false,
          -- memory = true,
        },
      },
    },
    -- pylsp = {
    --   cmd = { "pylsp" },
    --   filetypes = { "python" },
    --   single_file_support = true,
    --   configurationSources = { "" }, -- default is pycodestyle
    --   rope = { extensionModules = "", ropeFolder = {} },
    --   plugins = {
    --     jedi_completion = {
    --       enabled = true,
    --       eager = true,
    --       cache_for = { "numpy", "scipy" },
    --     },
    --     jedi_definition = {
    --       enabled = true,
    --       follow_imports = true,
    --       follow_builtin_imports = true,
    --     },
    --     jedi_hover = { enabled = true },
    --     jedi_references = { enabled = true },
    --     jedi_signature_help = { enabled = true },
    --     jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },
    --     preload = { enabled = false, modules = { "numpy", "scipy" } },
    --     mccabe = { enabled = false },
    --     mypy = { enabled = false },
    --     isort = { enabled = true },
    --     spyder = { enabled = false },
    --     memestra = { enabled = false },
    --     pycodestyle = { enabled = true }, -- not work
    --     flake8 = { enabled = true },
    --     pyflakes = { enabled = false },
    --     yapf = { enabled = false },
    --     pylint = {
    --       enabled = false,
    --       args = {
    --         "-f",
    --         "json",
    --         "--rcfile=" .. "~/.pylintrc",
    --       },
    --     },
    --     rope = { enabled = true },
    --     rope_completion = { enabled = true, eager = false },
    --     rope_autoimport = { enabled = true },
    --   },
    -- },
  },
}
return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
