return {
  {
    "edgy.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("edgy").setup({
        left = {
          {
            title = "Neo-Tree",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            pinned = true,
            open = "Neotree position=left filesystem",
          },
          {
            title = "Trouble",
            ft = "trouble",
            pinned = true,
            size = { height = 0.4 },
          },
        },
        bottom = {
          {
            ft = "snacks_terminal",
            size = { height = 0.4 },
            title = "%{b:snacks_terminal.id}: %{b:term_title}",
            filter = function(buf, win)
              return vim.w[win].snacks_win
                and vim.w[win].snacks_win.position == "bottom"
                and vim.w[win].snacks_win.relative == "editor"
            end,
          },
        },
        right = {
          {
            title = "Avante",
            ft = "Avante",
            pinned = true,
            size = { width = 0.3 },
          },
        },
        exit_when_last = true,
        options = {
          left = { size = 30 },
          bottom = { size = 0.3 },
          right = { size = 0.3 },
        },
      })
    end,
  },
}
