return {
  {
    "bufferline.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = function(bufnr)
            require("snacks").bufdelete(bufnr)
          end,
          right_mouse_command = function(bufnr)
            require("snacks").bufdelete(bufnr)
          end,
          indicator = {
            style = "icon",
            icon = "▎",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          separator_style = "thin",
          always_show_bufferline = true,
        },
      })
    end,
  },
}
