return {
    {
        "nvim-treesitter",
        lazy = false,
        auto_enable = true,
        after = function(plugin)
          ---@param buf integer
          ---@param language string
          local function treesitter_try_attach(buf, language)
            -- check if parser exists and load it
            if not vim.treesitter.language.add(language) then
              return false
            end
            -- enables syntax highlighting and other treesitter features
            vim.treesitter.start(buf, language)

            -- enables treesitter based folds
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
            -- ensure folds are open to begin with
            vim.o.foldlevel = 99

            -- enables treesitter based indentation
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            return true
          end

          local installable_parsers = require("nvim-treesitter").get_available()
          vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
              local buf, filetype = args.buf, args.match
              local language = vim.treesitter.language.get_lang(filetype)
              if not language then
                return
              end

              if not treesitter_try_attach(buf,language) then
                if vim.tbl_contains(installable_parsers, language) then
                  -- not already installed, so try to install them via nvim-treesitter if possible
                  require("nvim-treesitter").install(language):await(function()
                    treesitter_try_attach(buf, language)
                  end)
                end
              end
            end,
          })
        end,
      },
      {
        "nvim-treesitter-textobjects",
        auto_enable = true,
        lazy = false,
        before = function(plugin)
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
          -- Disable entire built-in ftplugin mappings to avoid conflicts.
          -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
          vim.g.no_plugin_maps = true

          -- Or, disable per filetype (add as you like)
          -- vim.g.no_python_maps = true
          -- vim.g.no_ruby_maps = true
          -- vim.g.no_rust_maps = true
          -- vim.g.no_go_maps = true
        end,
        after = function(plugin)
          require("nvim-treesitter-textobjects").setup {
            select = {
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
              -- You can choose the select mode (default is charwise 'v')
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * method: eg 'v' or 'o'
              -- and should return the mode ('v', 'V', or '<c-v>') or a table
              -- mapping query_strings to modes.
              selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                -- ['@class.outer'] = '<c-v>', -- blockwise
              },
              -- If you set this to `true` (default is `false`) then any textobject is
              -- extended to include preceding or succeeding whitespace. Succeeding
              -- whitespace has priority in order to act similarly to eg the built-in
              -- `ap`.
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * selection_mode: eg 'v'
              -- and should return true of false
              include_surrounding_whitespace = false,
            },
          }

          -- keymaps
          -- You can use the capture groups defined in `textobjects.scm`
          vim.keymap.set({ "x", "o" }, "am", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "im", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "ac", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "ic", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
          end)
          -- You can also use captures from other query groups like `locals.scm`
          vim.keymap.set({ "x", "o" }, "as", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
          end)

          -- NOTE: for more textobjects options, see the following link.
          -- This template is using the new `main` branch of the repo.
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main
        end,
      },
  {
    "rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    after = function(name)
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [''] = require('rainbow-delimiters').strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      })
    end,
  },
  {
    "indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    after = function(name)
        local highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        }

        local hooks = require("ibl.hooks")

        -- Ensure the highlight groups exist before ibl tries to use them
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
        end)

      require("ibl").setup({
        indent = {
          char = "│",
          highlight = highlight,
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          highlight = highlight,
        },
      })
      -- Integrate with rainbow-delimiters
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with" },
      { "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, desc = "Peek fold or hover" },
    },
    after = function(name)
      -- UFO needs these options
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
    end,
  },
}
