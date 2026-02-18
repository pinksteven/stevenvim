vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'

-- Line Numbers & Cursor
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false

-- Display / UI
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '100'
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.conceallevel = 2
vim.opt.ruler = false
vim.opt.synmaxcol = 240
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.startofline = true

vim.opt.lazyredraw = false

-- Sync yank with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Toggle wrap function
function ToggleWrap()
  vim.opt.wrap = not vim.opt.wrap:get()
end

-- Save file
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', '<esc><cmd>w<cr>', { silent = true, desc = 'Save file' })

-- Quit/Session
vim.keymap.set('n', '<leader>qq', '<cmd>quitall<cr><esc>', { silent = true, desc = 'Quit all' })
vim.keymap.set('n', '<leader>qs', '<cmd>SessionManager load_current_dir_session<cr>', { silent = true, desc = 'Restore session (cwd)' })
vim.keymap.set('n', '<leader>qS', '<cmd>SessionManager load_session<cr>', { silent = true, desc = 'Select session' })
vim.keymap.set('n', '<leader>ql', '<cmd>SessionManager load_last_session<cr>', { silent = true, desc = 'Restore last session' })
vim.keymap.set('n', '<leader>qw', '<cmd>SessionManager save_current_session<cr>', { silent = true, desc = 'Save session' })
vim.keymap.set('n', '<leader>qd', '<cmd>SessionManager delete_session<cr>', { silent = true, desc = 'Delete session' })

-- Toggle wrap
vim.keymap.set('n', '<leader>uw', ':lua ToggleWrap()<cr>', { silent = true, desc = 'Toggle Line Wrap' })

-- Move Lines
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<cr>gv=gv", { desc = 'Move line up' })
vim.keymap.set('v', '<A-Down>', ":m '>+1<cr>gv=gv", { desc = 'Move line down' })

-- Better indenting (stay in visual mode)
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Select all
vim.keymap.set('i', '<C-a>', '<cmd> norm! ggVG<cr>', { desc = 'Select all lines in buffer' })

-- Paste over without yanking deleted text
vim.keymap.set('x', 'p', '"_dP', { desc = 'Deletes to void register and paste over' })

-- Delete to void register
vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_d', { desc = 'Delete to void register' })

-- Window navigation
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to window up' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to window down' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to window right' })

-- Window management
vim.keymap.set('n', '<leader>wd', '<C-W>c', { silent = true, desc = 'Delete window' })
vim.keymap.set('n', '<leader>w-', '<C-W>s', { silent = true, desc = 'Split window below' })
vim.keymap.set('n', '<leader>w\\', '<C-W>v', { silent = true, desc = 'Split window right' })

-- Buffer navigation
vim.keymap.set('n', '<C-.>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Cycle to next buffer' })
vim.keymap.set('n', '<C-,>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Cycle to previous buffer' })
vim.keymap.set('n', '<C-x>', function() require("snacks").bufdelete() end, { desc = 'Delete buffer' })

-- Buffer management
vim.keymap.set('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Delete buffers to the right' })
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Delete buffers to the left' })
vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Delete other buffers' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle pin' })
vim.keymap.set('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', { desc = 'Delete non-pinned buffers' })
