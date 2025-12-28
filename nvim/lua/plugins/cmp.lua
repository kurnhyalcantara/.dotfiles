return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.mapping["<Tab>"] = nil
      opts.mapping["<S-Tab>"] = nil
      return opts
    end,
  },
}
