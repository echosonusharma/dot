-- --- Globals ---
vim.g.mapleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- --- Editor Options ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = '120'
vim.opt.textwidth = 120
vim.opt.completeopt = 'menu,menuone,fuzzy,noinsert'
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.wildoptions:append { 'fuzzy' }
vim.opt.path:append { '**' }
vim.opt.smoothscroll = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'
vim.opt.clipboard = 'unnamedplus'
vim.opt.shortmess:append("c") -- Don't show completion messages
vim.opt.undofile = true      -- Save undo history to a file

-- --- Plugins ---
local function gh(user, name)
  return 'https://github.com/' .. user .. '/' .. name
end

vim.pack.add({
  gh('rebelot', 'kanagawa.nvim'),
  gh('mikavilpas', 'yazi.nvim'),
  gh('nvim-tree', 'nvim-web-devicons'),
  gh('nvim-treesitter', 'nvim-treesitter'),
  gh('MeanderingProgrammer', 'render-markdown.nvim'),
  gh('brenoprata10', 'nvim-highlight-colors'),
  gh('nvim-lua', 'plenary.nvim'),
  gh('nvim-telescope', 'telescope.nvim'),
  gh('nvim-telescope', 'telescope-fzf-native.nvim'),
  gh('lewis6991', 'gitsigns.nvim'),
  gh('windwp', 'nvim-autopairs'),
  gh('mbbill', 'undotree'),
  gh('sphamba', 'smear-cursor.nvim'),
})

-- --- Plugin Configuration ---

-- Kanagawa theme
require('kanagawa').setup({
  theme = "wave",
  background = { dark = "wave", light = "lotus" },
})
vim.cmd("colorscheme kanagawa")

-- Yazi.nvim (File Explorer)
require('yazi').setup({
  open_for_directories = true,
  floating_window_scaling_factor = 0.9,
})

-- Markdown
require('render-markdown').setup({})

-- Gitsigns
require('gitsigns').setup({})

-- Autopairs
require('nvim-autopairs').setup({})

-- Cursor
require('smear_cursor').setup({
  stiffness = 0.8,                      -- 0.6      [0, 1]
  trailing_stiffness = 0.6,             -- 0.45     [0, 1]
  stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
  trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
  damping = 0.95,                       -- 0.85     [0, 1]
  damping_insert_mode = 0.95,           -- 0.9      [0, 1]
  distance_stop_animating = 0.5,        -- 0.1      > 0
})

-- Telescope
local ok_tele, telescope = pcall(require, 'telescope')
if ok_tele then
  telescope.setup({
    defaults = {
      layout_strategy = 'horizontal',
      prompt_prefix = " 🔍 ",
    },
  })

  -- Keymaps
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ cwd = vim.fn.getcwd() }) end, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({ cwd = vim.fn.getcwd() }) end, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

-- Treesitter (Safety check)
local ok_ts, ts = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  ts.setup({
    ensure_installed = { "lua", "go", "javascript", "typescript", "c", "cpp" },
    highlight = { enable = true },
  })
end

-- --- LSP & IDE Features ---

-- Global attachment logic
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- Enable completion
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Auto-format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format { bufnr = bufnr, async = false } end,
    })
  end,
})

-- Install language servers
-- Golang - go install golang.org/x/tools/gopls@latest
-- Typescript - npm i -g typescript typescript-language-server
-- C/C++ - sudo apt install clangd

-- Enable servers
vim.lsp.enable({ 'gopls', 'ts_ls', 'clangd' })

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded' },
})

-- Auto-completion triggering while typing
vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    -- Skip if in Telescope prompt or if omnifunc isn't set
    if vim.bo.filetype == 'TelescopePrompt' or vim.bo.omnifunc == "" then
      return
    end

    if vim.fn.pumvisible() == 0 and vim.v.char:match("[%w%.%/]") then
      vim.schedule(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", true)
      end)
    end
  end,
})

-- --- Floating Terminal ---
local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate centered position
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create or reuse buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf or -1) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
    vim.cmd('startinsert')
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- --- Keymaps & Autocommands ---

-- Fast escape and config reload
vim.keymap.set('i', ',,', '<Esc>')
vim.keymap.set('n', '<leader>r', function()
  vim.cmd('source $MYVIMRC')
  print('Config reloaded!')
end, { silent = true })

-- File explorer mapping
vim.keymap.set("n", "-", "<cmd>Yazi<CR>", { desc = "Open explorer" })

-- Undotree mapping
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })

-- Floating terminal mapping
vim.keymap.set({ 'n', 't' }, '<leader>t', toggle_terminal, { desc = 'Toggle Floating Terminal' })

-- Disable arrow keys
local arrows = { "<Up>", "<Down>", "<Left>", "<Right>" }
for _, key in ipairs(arrows) do
  vim.keymap.set({ "n", "v" }, key, "<Nop>", { silent = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})
