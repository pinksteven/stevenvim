return {
  {
    "neovim-session-manager",
    event = "DeferredUIEnter",
    after = function(name)
      local config = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_not_normal = true,
        autosave_ignore_filetypes = {
          "gitcommit",
          "gitrebase",
          "alpha",
        },
        autosave_only_in_session = false,
      })
    end,
  },
  {
    "alpha-nvim",
    event = "VimEnter",
    after = function(name)
      local alpha = require("alpha")

      -- ── Helpers ──────────────────────────────────────────────────────
      local if_nil = vim.F.if_nil

      local function button(sc, txt, keybind, keybind_opts)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        local opts = {
          position = "center",
          shortcut = sc,
          cursor = 3,
          width = 50,
          align_shortcut = "right",
          hl_shortcut = "AlphaShortcut",
        }
        if keybind then
          keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
          opts.keymap = { "n", sc_, keybind, keybind_opts }
        end
        local function on_press()
          local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
          vim.api.nvim_feedkeys(key, "t", false)
        end
        return {
          type = "button",
          val = txt,
          on_press = on_press,
          opts = opts,
        }
      end

      local function info_text(text)
        return {
          type = "text",
          val = text,
          opts = { hl = "AlphaInfoLabel", position = "center" },
        }
      end

      -- ── Developer Excuse ────────────────────────────────────────────
      local function get_excuse()
        local result = vim.fn.system("curl -s --max-time 2 http://www.developerexcuses.com/ 2>/dev/null")
        local excuse = result:match('<a[^>]*>([^<]+)</a>')
        if excuse and excuse ~= "" then
          return excuse
        end
        return "*insert excuse*"
      end

      local function make_header()
        local excuse = get_excuse()

        -- Try figlet for big text
        local figlet = vim.fn.system("echo " .. vim.fn.shellescape(excuse) .. " | figlet -w 120 -f smslant 2>/dev/null")
        if vim.v.shell_error == 0 and figlet and figlet ~= "" then
          local lines = {}
          for line in figlet:gmatch("[^\n]+") do
            table.insert(lines, line)
          end
          if #lines > 0 then
            return lines
          end
        end

        -- Try toilet as alternative
        local toilet = vim.fn.system("echo " .. vim.fn.shellescape(excuse) .. " | toilet -w 80 -f smblock 2>/dev/null")
        if vim.v.shell_error == 0 and toilet and toilet ~= "" then
          local lines = {}
          for line in toilet:gmatch("[^\n]+") do
            table.insert(lines, line)
          end
          if #lines > 0 then
            return lines
          end
        end

        -- Fallback: framed excuse text
        local max_len = math.max(#excuse + 4, 40)
        local border = "═"
        local top = "╔" .. string.rep(border, max_len) .. "╗"
        local bot = "╚" .. string.rep(border, max_len) .. "╝"
        local pad = max_len - #excuse - 2
        local lpad = math.floor(pad / 2)
        local rpad = pad - lpad
        local mid = "║ " .. string.rep(" ", lpad) .. excuse .. string.rep(" ", rpad) .. " ║"
        local empty = "║" .. string.rep(" ", max_len) .. "║"

        return {
          "",
          top,
          empty,
          mid,
          empty,
          bot,
          "",
        }
      end

      -- ── Header ───────────────────────────────────────────────────────
      local header = {
        type = "text",
        val = make_header(),
        opts = { hl = "AlphaHeader", position = "center" },
      }

      -- ── Buttons / Keys ──────────────────────────────────────────────
      local keys = {
        type = "group",
        val = {
          button("f", "  Find File", "<cmd>Telescope find_files<cr>"),
          button("g", "  Live Grep", "<cmd>Telescope live_grep<cr>"),
          button("n", "  New File", "<cmd>ene <BAR> startinsert<cr>"),
          button("y", "  Yazi", "<cmd>Yazi cwd<cr>"),
          button("r", "  Restore Session", "<cmd>SessionManager load_current_dir_session<cr>"),
          button("s", "  Sessions", "<cmd>SessionManager load_session<cr>"),
          button("p", "  Find Repo", function()
            local home = vim.fn.expand("~")
            local search_dirs = {}
            for _, dir in ipairs({ "Documents", "Projects", "repos", "src", "dev", "code", "work", ".config" }) do
              local full = home .. "/" .. dir
              if vim.fn.isdirectory(full) == 1 then
                table.insert(search_dirs, full)
              end
            end
            if #search_dirs == 0 then
              search_dirs = { home }
            end

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local cmd = { "fd", "--type", "d", "--hidden", "--no-ignore", "--max-depth", "4", "^\\.git$" }
            for _, dir in ipairs(search_dirs) do
              table.insert(cmd, "--search-path")
              table.insert(cmd, dir)
            end

            local handle = io.popen(table.concat(cmd, " ") .. " 2>/dev/null")
            local result = handle and handle:read("*a") or ""
            if handle then handle:close() end

            local repos = {}
            for line in result:gmatch("[^\n]+") do
              local repo_path = line:gsub("/.git/?$", "")
              local display = repo_path:gsub("^" .. vim.pesc(home), "~")
              table.insert(repos, { display = display, path = repo_path })
            end
            table.sort(repos, function(a, b) return a.display < b.display end)

            pickers.new({}, {
              prompt_title = "Git Repositories",
              finder = finders.new_table({
                results = repos,
                entry_maker = function(entry)
                  return { value = entry.path, display = entry.display, ordinal = entry.display }
                end,
              }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  if selection then
                    vim.cmd("cd " .. vim.fn.fnameescape(selection.value))
                    vim.cmd("Telescope find_files")
                  end
                end)
                return true
              end,
            }):find()
          end),
          button("q", "  Quit", "<cmd>qa<cr>"),
        },
        opts = { spacing = 1 },
      }

      -- ── Recent Files ────────────────────────────────────────────────
      local function recent_files_section()
        local oldfiles = vim.v.oldfiles or {}
        local home = vim.fn.expand("~")
        local items = {
          info_text("  Recent Files"),
          { type = "padding", val = 1 },
        }

        local count = 0
        for _, file in ipairs(oldfiles) do
          if count >= 8 then break end
          local expanded = vim.fn.expand(file)
          if vim.fn.filereadable(expanded) == 1 then
            count = count + 1
            local display = expanded:gsub("^" .. vim.pesc(home), "~")
            local key = tostring(count)
            table.insert(items, button(key, "  " .. display, "<cmd>e " .. vim.fn.fnameescape(expanded) .. "<cr>"))
          end
        end

        if count == 0 then
          table.insert(items, {
            type = "text",
            val = "   No recent files",
            opts = { hl = "Comment", position = "center" },
          })
        end

        return {
          type = "group",
          val = items,
          opts = { spacing = 0 },
        }
      end

      -- ── Projects ────────────────────────────────────────────────────
      local function projects_section()
        local oldfiles = vim.v.oldfiles or {}
        local home = vim.fn.expand("~")
        local seen = {}
        local projects = {}

        for _, file in ipairs(oldfiles) do
          if #projects >= 5 then break end
          local expanded = vim.fn.expand(file)
          local dir = vim.fn.fnamemodify(expanded, ":h")
          local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")
          if vim.v.shell_error == 0 and git_root[1] and not seen[git_root[1]] then
            seen[git_root[1]] = true
            table.insert(projects, git_root[1])
          end
        end

        local items = {
          info_text("  Projects"),
          { type = "padding", val = 1 },
        }

        if #projects == 0 then
          table.insert(items, {
            type = "text",
            val = "   No recent projects",
            opts = { hl = "Comment", position = "center" },
          })
        end

        for i, project in ipairs(projects) do
          local display = project:gsub("^" .. vim.pesc(home), "~")
          local project_name = vim.fn.fnamemodify(project, ":t")
          local key = "p" .. tostring(i)
          table.insert(items, button(key, "  " .. project_name .. "  " .. display,
            "<cmd>cd " .. vim.fn.fnameescape(project) .. " | Telescope find_files<cr>"))
        end

        return {
          type = "group",
          val = items,
          opts = { spacing = 0 },
        }
      end

      -- ── Footer ──────────────────────────────────────────────────────
      local footer = {
        type = "text",
        val = function()
          return { os.date(" %Y-%m-%d   %H:%M:%S") }
        end,
        opts = { hl = "AlphaFooter", position = "center" },
      }

      -- ── Highlight Groups ────────────────────────────────────────────
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f38ba8", bold = true })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a6adc8", italic = true })
      vim.api.nvim_set_hl(0, "AlphaInfoLabel", { fg = "#f9e2af", bold = true })

      -- ── Layout ──────────────────────────────────────────────────────
      local layout = {
        layout = {
          { type = "padding", val = 2 },
          header,
          { type = "padding", val = 2 },
          keys,
          { type = "padding", val = 2 },
          recent_files_section(),
          { type = "padding", val = 2 },
          projects_section(),
          { type = "padding", val = 2 },
          footer,
        },
        opts = {
          margin = 5,
          noautocmd = true,
        },
      }

      alpha.setup(layout)

      -- ── Auto-commands ───────────────────────────────────────────────
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
          vim.wo.winbar = ""
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaClosed",
        callback = function()
          vim.opt.laststatus = 3
          vim.opt.showtabline = 2
        end,
      })
    end,
  },
}
