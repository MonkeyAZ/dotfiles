local jdtls = require('jdtls')
local jdtls_dap = require('jdtls.dap')
local jdtls_setup = require('jdtls.setup')
local home = os.getenv('HOME')

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = jdtls_setup.find_root(root_markers)

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace' .. project_name

local path_to_mason_packages = home .. '/.local/share/nvim/mason/packages'

local path_to_jdtls = path_to_mason_packages .. '/jdtls'
local path_to_jdebug = path_to_mason_packages .. '/java-debug-adapter'
local path_to_jtest = path_to_mason_packages .. '/java-test'

local path_to_config = path_to_jdtls .. '/config_linux'
local lombok_path = path_to_jdtls .. '/lombok.jar'

local path_to_jar = path_to_jdtls .. '/plugins/org.eclipse.equinox.launcher.jar'

local bundles = {
  vim.fn.glob(path_to_jdebug .. '/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar', true),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. '/extension/server/*.jar', true), '\n'))

-- LSP settings for Java.
local on_attach = function(_, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls_dap.setup_dap_main_class_configs()

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local capabilities = {
  workspace = {
    configuration = true,
  },
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
  },
}

local config = {
  flags = {
    allow_incremental_sync = true,
  },
}

config.cmd = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '-javaagent:' .. lombok_path,
  '--add-modules=ALL-SYSTEM',
  '--add-opens',
  'java.base/java.util=ALL-UNNAMED',
  '--add-opens',
  'java.base/java.lang=ALL-UNNAMED',

  '-jar',
  path_to_jar,

  '-configuration',
  path_to_config,

  '-data',
  workspace_dir,
}

config.settings = {
  java = {
    references = {
      includeDecompiledSources = true,
    },
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
    },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = 'fernflower' },
    -- implementationsCodeLens = {
    -- 	enabled = true,
    -- },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      filteredTypes = {
        'com.sun.*',
        'io.micrometer.shaded.*',
        'java.awt.*',
        'jdk.*',
        'sun.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        -- flags = {
        -- 	allow_incremental_sync = true,
        -- },
      },
      useBlocks = true,
    },
    -- configuration = {
    --     runtimes = {
    --         {
    --             name = "java-17-openjdk",
    --             path = "/usr/lib/jvm/default-runtime/bin/java"
    --         }
    --     }
    -- }
    -- project = {
    -- 	referencedLibraries = {
    -- 		"**/lib/*.jar",
    -- 	},
    -- },
  },
}

config.on_attach = on_attach
config.capabilities = capabilities
config.on_init = function(client, _)
  client.notify('workspace/didChangeConfiguration', { settings = config.settings })
end

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities,
}

-- Set Java Specific Keymaps
--require("jdtls.keymaps")
--
-- Start Server
require('jdtls').start_or_attach(config)
