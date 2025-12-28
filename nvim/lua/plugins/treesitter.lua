return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
