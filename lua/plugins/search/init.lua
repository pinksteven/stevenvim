return {
  {
    "telescope.nvim",
    cmd = "Telescope",
    keys = {
      -- File pickers
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

      -- Search
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string under cursor" },

      -- LSP
      { "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP definitions" },
      { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP implementations" },
      { "<leader>fR", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
      { "<leader>ft", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP type definitions" },
      { "<leader>fds", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fws", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },

      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },

      -- Misc
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location list" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Vim options" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>f/", "<cmd>Telescope search_history<cr>", desc = "Search history" },

      -- Diagnostics
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    after = function(name)
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },

  {
    "telescope-fzf-native.nvim",
    dep_of = { "telescope.nvim" },
  },

  {
    "telescope-ui-select.nvim",
    dep_of = { "telescope.nvim" },
  },

  {
    "flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    after = function(name)
      require("flash").setup({
        labels = "asdfghjklqwertyuiopzxcvbnm",
        search = {
          multi_window = true,
          forward = true,
          wrap = true,
          mode = "exact",
          incremental = false,
        },
        jump = {
          jumplist = true,
          pos = "start",
          history = false,
          register = false,
          nohlsearch = false,
          autojump = false,
        },
        label = {
          uppercase = true,
          rainbow = {
            enabled = false,
            shade = 5,
          },
        },
        modes = {
          search = {
            enabled = true,
          },
          char = {
            enabled = true,
            keys = { "f", "F", "t", "T", ";", "," },
            jump_labels = true,
          },
        },
      })
    end,
  },
}
