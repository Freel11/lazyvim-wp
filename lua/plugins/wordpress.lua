local composer_bin = vim.fn.expand("~/.config/composer/vendor/bin")

-- Dynamically find the WordPress Core files based on current project
local function get_wp_includes()
  local cwd = vim.fn.getcwd()
  -- Look for Local's standard 'app/public' structure in the path
  local public_path = string.match(cwd, "^(.*app/public)")

  if public_path then
    return {
      public_path .. "/wp-includes",
      public_path .. "/wp-admin/includes",
      -- Included Understrap parent theme's function definitions
      public_path .. "/wp-content/themes/understrap",
    }
  end

  -- Fallback to the global stubs if we are working on a random standalone file
  return { vim.fn.expand("~/.config/composer/vendor/php-stubs/wordpress-stubs") }
end

local wp_core_paths = get_wp_includes()

return {
  -- 1. Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "intelephense" })
    end,
  },

  -- 2. Nvim-Lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        php = { "phpcs" },
      },
      linters = {
        phpcs = {
          cmd = composer_bin .. "/phpcs",
          args = {
            "-q",
            "--report=json",
            "--standard=WordPress",
            "-",
          },
        },
      },
    },
  },

  -- 3. Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "phpcbf" },
      },
      formatters = {
        phpcbf = {
          command = composer_bin .. "/phpcbf",
          prepend_args = { "--standard=WordPress" },
          valid_exit_codes = { 0, 1 },
        },
      },
    },
  },

  -- 4. LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.phpactor = false

      opts.servers.intelephense = {
        filetypes = { "php" },
        settings = {
          intelephense = {
            environment = {
              -- Combine the dynamic WP paths with global ACF stubs
              includePaths = {
                vim.fn.expand("~/.config/composer/vendor/php-stubs/acf-pro-stubs"),
                wp_core_paths[1],
                wp_core_paths[2],
                wp_core_paths[3],
              },
            },
          },
        },
      }
    end,
  },
}
