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
