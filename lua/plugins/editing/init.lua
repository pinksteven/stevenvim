return {
    {
        "which-key.nvim",
        event = "DeferredUIEnter",
        after = function(name)
            require("which-key").setup({
                preset = "modern",
                delay = 300,
                icons = {
                  mappings = true,
                  keys = {},
                },
                spec = {
                  { "<leader>f", group = "file/find" },
                  { "<leader>b", group = "buffer" },
                  { "<leader>c", group = "code" },
                  { "<leader>g", group = "git" },
                  { "<leader>s", group = "search" },
                  { "<leader>u", group = "ui/toggle" },
                  { "<leader>w", group = "windows" },
                  { "<leader>x", group = "diagnostics/quickfix" },
                  { "<leader>q", group = "quit/session" },
                },
            })
        end,
    },
    {
        "mini.nvim",
        event = "DeferredUIEnter",
        after = function(name)
              require("mini.comment").setup()
              require("mini.surround").setup()
              require("mini.ai").setup()
              require("mini.bracketed").setup()
              require("mini.pairs").setup()
            end
    },
    {
        "undotree",
        cmd = {
          "UndotreeToggle",
          "UndotreeHide",
          "UndotreeShow",
          "UndotreeFocus",
        },
        keys = {
          { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" },
        },
        after = function(name)
          -- Configuration before loading
          vim.g.undotree_WindowLayout = 2
          vim.g.undotree_SplitWidth = 40
          vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    {
        "vim-sleuth",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        after = function(name)
            require("todo-comments").setup({
                signs = true, -- show icons in sign column
                keywords = {
                    FIX = {
                        icon = " ",
                        color = "error",
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                    },
                    TODO = { icon = "", color = "info" },
                    HACK = { icon = "", color = "warning" },
                    WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = "⚡", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = "", color = "hint", alt = { "INFO" } },
                    TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
            })
        end,
    }
}
