-- =============================================
-- Neovim Configuration — Minimal Shell
-- =============================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.cursorline = true

-- Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250

-- Leader key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        opts = {
            ensure_installed = { "lua", "typescript", "tsx", "bash", "css", "html", "json", "markdown", "python", "toml", "yaml" },
            highlight = { enable = true },
        },
    },
})

-- Colorscheme (after lazy so treesitter highlights are available)
dofile(vim.fn.stdpath("config") .. "/lua/disco-elysium.lua")
