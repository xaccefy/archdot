-- ─────────────────────────────────────────────────────────────
-- Ready-to-use Neovim config (lazy.nvim)
-- Transparent oxocarbon · Wayland text-only clipboard · cmp +
-- snippets + Mason. Restart nvim / run :Lazy sync after first launch.
-- ─────────────────────────────────────────────────────────────

vim.g.mapleader = " "
vim.g.have_nerd_font = true

-- ── Editor options ──
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Quality-of-life defaults
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.inccommand = "split"
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ── Clipboard (Wayland, text-only) ──
-- An image copied in the PI UI lands on the system clipboard as
-- /tmp/pi-clipboard-*.png. Force text/plain so it is never pasted into a
-- buffer as a stray path / blank gap. Filtered at the provider, not in nvim.
vim.g.clipboard = {
    name = "wayland-text-only",
    copy = {
        ["+"] = "/usr/sbin/wl-copy --type text/plain",
        ["*"] = "/usr/sbin/wl-copy --type text/plain --primary",
    },
    paste = {
        ["+"] = "/usr/sbin/wl-paste --type text/plain --no-newline | grep -v -E '/tmp/pi-clipboard-[0-9a-f-]+\\.png' || true",
        ["*"] = "/usr/sbin/wl-paste --type text/plain --primary --no-newline | grep -v -E '/tmp/pi-clipboard-[0-9a-f-]+\\.png' || true",
    },
    cache_enabled = true,
}

-- ── Lazy.nvim bootstrap ──
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──
require("lazy").setup({
    -- Colorscheme
    { "nyoom-engineering/oxocarbon.nvim" },
    { "folke/tokyonight.nvim" },

    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP + easy server installs
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Completion (+ buffer/path/snippet sources)
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
    },

    -- File finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Git signs in the gutter
    { "lewis6991/gitsigns.nvim" },

    -- File explorer (modal, not tree-based)
    { "stevearc/oil.nvim" },

    -- IDE-style file tree sidebar (toggle with <C-n>)
    { "nvim-tree/nvim-tree.lua", version = "*" },

    -- Floating terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
    },

    -- Statusline
    { "nvim-lualine/lualine.nvim" },

    -- Surround with quotes/brackets/tags
    { "kylechui/nvim-surround" },

    -- Keymap discovery (press <Space> and wait)
    { "folke/which-key.nvim" },

    -- Jump to any visible location
    { "folke/flash.nvim" },

    -- Auto-close brackets
    { "windwp/nvim-autopairs" },

    -- Comment with gcc / gc
    { "numToStr/Comment.nvim" },
})

-- ── Colorscheme ──
pcall(vim.cmd.colorscheme, "tokyonight-night")

-- Transparent background + visible comments. Every group that can paint a
-- background must be cleared, or the colorscheme's dark #161616 bleeds into
-- the gutter / end-of-buffer / current-line-number area as dark blocks.
local function set_transparency()
    local groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "FoldColumn",
        "EndOfBuffer",
        "NonText",
        "CursorLineNr",
    }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
    vim.api.nvim_set_hl(0, "Comment", { fg = "#7ecf6f", italic = true })
end
set_transparency()

-- Hide the ~ end-of-buffer markers (bg already transparent above)
vim.opt.fillchars:append({ eob = " " })

-- ── Plugin configurations ──
-- Wrapped in pcall so first-time bootstrap (before :Lazy sync) doesn't crash.

pcall(function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "c", "cpp", "go", "python", "lua", "vim", "vimdoc",
            "javascript", "typescript", "html", "css", "markdown",
        },
        auto_install = true,
        highlight = { enable = true },
    })
end)

-- LSP: Mason for one-key installs, cmp capabilities, enabled servers.
pcall(function()
    require("lspconfig")

    require("mason").setup()
    require("mason-lspconfig").setup({
        automatic_enable = true, -- any server installed via :Mason auto-starts
    })

    -- Wire cmp capabilities (incl. snippets) into every LSP client
    vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- Explicitly enabled servers (also auto-enabled once installed via Mason)
    for _, server in ipairs({ "clangd", "gopls", "basedpyright", "ts_ls", "ruff" }) do
        vim.lsp.enable(server)
    end
end)

-- LSP keymaps (applies whenever any LSP attaches to a buffer)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufopts = { noremap = true, silent = true, buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
        -- Format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = args.buf })
            end,
        })
    end,
})

pcall(function()
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require("luasnip").expand_or_locally_jumpable() then
                    require("luasnip").expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require("luasnip").locally_jumpable(-1) then
                    require("luasnip").jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                return vim_item
            end,
        },
        window = {
            completion = cmp.config.window.bordered({
                max_height = 15,
                max_width = 60,
            }),
        },
    })
end)

pcall(function()
    require("nvim-autopairs").setup()
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)

pcall(function()
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
            end
            map("n", "]h", function() gs.next_hunk() end)
            map("n", "[h", function() gs.prev_hunk() end)
            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end)
            map("n", "<leader>gd", function() gs.diffthis() end)
            map("n", "<leader>gp", gs.preview_hunk)
        end,
    })
end)

pcall(function()
    require("oil").setup()
end)

pcall(function()
    require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = { side = "left", width = 22 },
        update_focused_file = { enable = true },
        filters = { dotfiles = false },
    })
    -- <C-n> may be intercepted by the terminal; <leader>e (space+e) is reliable
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    -- Open the IDE-style sidebar on startup so it's visible like an editor
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function() pcall(require("nvim-tree.api").tree.open) end,
    })
end)

pcall(function()
    require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = {
            border = "curved",
        },
    })
end)

pcall(function()
    local colors = {
        teal   = "#08bdba",
        blue   = "#78a9ff",
        purple = "#be95ff",
        green  = "#42be65",
        pink   = "#ee5396",
        yellow = "#f1c21b",
        orange = "#ff832b",
        gray   = "#525252",
        bg     = "#161616",
        surf   = "#262626",
        text   = "#f4f4f4",
    }

    local starship_theme = {
        normal = {
            a = { fg = colors.bg, bg = colors.teal, gui = "bold" },
            b = { fg = colors.blue, bg = colors.surf },
            c = { fg = colors.text, bg = colors.bg },
            x = { fg = colors.green, bg = colors.bg },
            y = { fg = colors.yellow, bg = colors.bg },
            z = { fg = colors.teal, bg = colors.bg },
        },
        insert = {
            a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        },
        visual = {
            a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
        },
        replace = {
            a = { fg = colors.bg, bg = colors.pink, gui = "bold" },
        },
        command = {
            a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
        },
        inactive = {
            a = { fg = colors.gray, bg = colors.bg },
            b = { fg = colors.gray, bg = colors.bg },
            c = { fg = colors.gray, bg = colors.bg },
        },
    }

    require("lualine").setup({
        options = {
            theme = starship_theme,
            component_separators = { left = "", right = "" },
            section_separators = { left = " ", right = " " },
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    fmt = function(str) return "› " .. str:sub(1, 1) .. " " end,
                },
            },
            lualine_b = {
                { "branch", icon = " " },
                { "diff", colored = true, symbols = { added = "+", modified = "~", removed = "-" } },
            },
            lualine_c = {
                { "filename", path = 1, symbols = { modified = " ●", readonly = " 󰌾", unnamed = "[No Name]" } },
            },
            lualine_x = {
                { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
                {
                    "filetype",
                    fmt = function(str) return str:lower() end,
                },
            },
            lualine_y = { "progress" },
            lualine_z = {
                { "location", fmt = function(str) return " " .. str .. " " end },
            },
        },
    })
end)

pcall(function()
    require("nvim-surround").setup()
end)

pcall(function()
    require("Comment").setup()
end)

pcall(function()
    require("which-key").setup()
end)

pcall(function()
    require("flash").setup()
end)

-- ── Telescope keymaps ──
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- ── Flash: s to jump, S to pick a syntax node ──
pcall(function()
    vim.keymap.set({ "n", "x", "o" }, "s", require("flash").jump)
    vim.keymap.set({ "n", "x", "o" }, "S", require("flash").treesitter)
end)

-- ── Highlight yanked text ──
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})

-- ── Terminal keymaps ──
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm direction=horizontal<CR>")
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- ── Oil keymaps ──
vim.keymap.set("n", "-", "<CMD>Oil<CR>")
