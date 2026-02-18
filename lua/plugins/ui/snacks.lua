return {
  {
    "snacks.nvim",
    event = "DeferredUIEnter",
    keys = {
      { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
      { "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
      { "<C-/>", function() require("snacks").terminal() end, desc = "Toggle Terminal" },
      { "<C-_>", function() require("snacks").terminal() end, desc = "which_key_ignore" },
      { "<leader>z", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z", function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
    },
    after = function(plugin)
      require("snacks").setup({
        -- Buffer delete
        bufdelete = { enabled = true },

        -- Terminal
        terminal = {},

        -- Zen mode
        zen = { enabled = true },

        -- Lazygit in floating window
        lazygit = { enabled = true },

        -- Other useful features
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
      })
    end,
  },
}
