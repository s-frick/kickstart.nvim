local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

-- Setup config
local config = {}

-- Setup Workspace
local home = os.getenv "HOME"
local workspace_path = home .. '/.local/share/jdtls/workspaces/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Setup Capabilities
local jar_patterns = {
  '/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
  '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
  '/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar',
  '/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
  '/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar',
  '/dev/testforstephen/vscode-pde/server/*.jar'
}
local plugin_path =
'/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/'
local bundle_list = vim.tbl_map(
  function(x) return require('jdtls.path').join(plugin_path, x) end,
  {
    'org.eclipse.jdt.junit4.runtime_*.jar',
    'org.eclipse.jdt.junit5.runtime_*.jar',
    'org.junit.jupiter.api*.jar',
    'org.junit.jupiter.engine*.jar',
    'org.junit.jupiter.migrationsupport*.jar',
    'org.junit.jupiter.params*.jar',
    'org.junit.vintage.engine*.jar',
    'org.opentest4j*.jar',
    'org.junit.platform.commons*.jar',
    'org.junit.platform.engine*.jar',
    'org.junit.platform.launcher*.jar',
    'org.junit.platform.runner*.jar',
    'org.junit.platform.suite.api*.jar',
    'org.apiguardian*.jar'
  }
)
vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
    if not vim.endswith(bundle, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
        and not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
      table.insert(bundles, bundle)
    end
  end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities,
}

config.cmd = {
  'java', -- or '/path/to/java17_or_newer/bin/java'
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '--add-modules=ALL-SYSTEM',
  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  '-jar',
  '/home/sfrick/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
  '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
  '-data', workspace_dir
}
config.root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' })
config.settings = {
  java = {
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = {},
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
    },
    references = {
      includeDecompiledSources = true,
    },
    inlayHints = {
      parameterNames = {
        enabled = "all", -- literals, all, none
      },
    },
    format = {
      enabled = true,
    },
  },
  signatureHelp = { enabled = true },
  extendedClientCapabilities = extendedClientCapabilities,
}
config["on_attach"] = function(client, bufnr)
  local _, _ = pcall(vim.lsp.codelens.refresh)
  require("jdtls").setup_dap({ hotcodereplace = 'auto' })
  require("jdtls").setup.add_commands()
  local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
  print("jdtls_dap: ")
  print(jdtls_dap)
  if status_ok then
    jdtls_dap.setup_dap_main_class_configs()
  end
  local opts = function(desc)
    return { silent = true, buffer = bufnr, desc = desc }
  end
  print("Load java keymaps")
  vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts("[L]SP: [O]rganize Imports"))
  vim.keymap.set('n', "<leader>lT", jdtls.test_class, opts("[T]est Class"))
  vim.keymap.set('n', "<leader>lt", jdtls.test_nearest_method, opts("[L]SP: [t]est Method"))
  vim.keymap.set('n', "<leader>lv", jdtls.extract_variable, opts("[L]SP: Extract [V]ariable"))
  vim.keymap.set('v', '<leader>lm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    opts("[L]SP: Extract [M]ethod"))
  vim.keymap.set('n', "<leader>lc", jdtls.extract_constant, opts("[L]SP: Extract [C]onstant"))
  -- local create_command = vim.api.nvim_buf_create_user_command
  -- create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
  --   nargs = 0,
  -- })
end

-- mute; having progress reports is enough
-- config.handlers['language/status'] = function() end
jdtls.start_or_attach(config)

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local vopts = {
  mode = "v",     -- VISUAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {
  C = {
    name = "Java",
    o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
    v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
    c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
    t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
    T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
    u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
    r = { "<Cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", "Reload DAP" }
  },
}

local vmappings = {
  C = {
    name = "Java",
    v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
    c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
    m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(vmappings, vopts)
