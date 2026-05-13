-- In lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "scss",
        "javascript",
        "tsx",
        "typescript",
        "vim",
      },
    },
  },
}
