return {
  {
    "yazi.nvim",
    event = "DeferredUIEnter",
    keys = {
      { "<leader>E", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Open yazi at current file" },
      { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
      { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
    },
    after = function(name)
      require("yazi").setup({
        open_for_directories = false,
        floating_window_scaling_factor = 0.9,
        yazi_floating_window_border = "rounded",
        keymaps = {
          show_help = "<f1>",
          open_file_in_vertical_split = "<c-v>",
          open_file_in_horizontal_split = "<c-x>",
          open_file_in_tab = "<c-t>",
          grep_in_directory = "<c-s>",
          cycle_open_buffers = "<tab>",
          copy_relative_path_to_selected_files = "<c-y>",
          send_to_quickfix_list = "<c-q>",
        },
      })
    end,
  },
}
