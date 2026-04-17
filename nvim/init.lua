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
-- vim.opt.path:append { '**' } -- Removed to prevent performance issues in large directories
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
  gh('rose-pine', 'neovim'),
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
  gh('neovim', 'nvim-lspconfig'),
  gh('mason-org', 'mason.nvim'),
  gh('mason-org', 'mason-lspconfig.nvim'),
  gh('WhoIsSethDaniel', 'mason-tool-installer.nvim'),
  gh('Saghen', 'blink.cmp'),
})

-- --- Plugin Configuration ---

-- Rose Pine theme
require('rose-pine').setup({
  variant = 'auto',
  dark_variant = 'main',
  extend_background_behind_tabs = true,
})
vim.cmd("colorscheme rose-pine")

-- Icons
require('nvim-web-devicons').setup({})

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
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

-- Treesitter (Safety check)
local ok_ts, ts = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  ts.setup({
    ensure_installed = { "lua", "go", "javascript", "typescript", "c", "cpp", "markdown", "markdown_inline" },
    highlight = { enable = true },
  })
end

-- --- LSP & IDE Features ---
vim.opt.completeopt:append("noselect")

-- Mason Setup
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
  ensure_installed = {
    "lua_ls",
    "stylua",
    "gopls",
    "typescript-language-server",
    "clangd",
  }
})

-- Blink.cmp Setup
require("blink.cmp").setup({
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = {
      auto_show = true,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
})

-- Global attachment logic
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Completion handled by blink.cmp (Native 0.11/0.12 API used by plugin)

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

-- Configure lua_ls (Neovim 0.11+ config API)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Enable servers
vim.lsp.enable({ 'lua_ls', 'gopls', 'ts_ls', 'clangd' })

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded' },
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
    state.floating.win = -1
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
