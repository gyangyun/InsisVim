--- @param config PythonConfig
return function(config)
  return {

    getFormatOnSavePattern = function()
      if config.format_on_save then
        return { "*.py" }
      end
      return {}
    end,

    getTSEnsureList = function()
      return { "python" }
    end,

    getLSPEnsureList = function()
      if config.lsp == "pylsp" then
        return { "pylsp" }
      end
      return {}
    end,

    getLSPConfigMap = function()
      if config.lsp == "pylsp" then
        return {
          pylsp = require("insis.lsp.config.pylsp"),
        }
      end
      return {}
    end,

    getToolEnsureList = function()
      local formatter = {}
      -- 同时支持back和isort
      if type(config.formatter) == "string" then
        formatter = { config.formatter }
      elseif type(config.formatter) == "table" then
        formatter = config.formatter
      else
        return {}
      end

      local ensure_l = {}
      -- 同时支持back和isort
      for _, value in pairs(formatter) do
        if value == "black" then
          table.insert(ensure_l, "black")
        end
        if value == "isort" then
          table.insert(ensure_l, "isort")
        end
      end
      return ensure_l
    end,

    getNulllsSources = function()
      local null_ls = pRequire("null-ls")
      if not null_ls then
        return {}
      end

      local formatter = {}
      -- 同时支持back和isort
      if type(config.formatter) == "string" then
        formatter = { config.formatter }
      elseif type(config.formatter) == "table" then
        formatter = config.formatter
      else
        return {}
      end

      local sources = {}
      -- 同时支持back和isort
      for _, value in pairs(formatter) do
        if value == "black" then
          table.insert(sources, null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }))
        end
        if value == "isort" then
          table.insert(sources, null_ls.builtins.formatting.isort)
        end
      end
      return sources
    end,

    getNeotestAdapters = function()
      return {}
    end,
  }
end
