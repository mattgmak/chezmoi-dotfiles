-- chezmoi:template:left-delimiter="# [[" right-delimiter=]]
local is_vscode = vim.g.vscode ~= nil
-- test

-- <leader> key
vim.g.mapleader = ' '

-- open config
vim.cmd('nmap <leader>cc :e ~/AppData/Local/nvim/init.lua<cr>')

-- save
vim.keymap.set('n', '<leader>s', '<cmd>w<cr>', {
    silent = true
})

-- motion keys (helldivers mappings)

vim.keymap.set({'n', 'v'}, 'j', 'k')
vim.keymap.set({'n', 'v'}, 'k', 'j')
vim.keymap.set({'n', 'v'}, 'l', 'h')
vim.keymap.set({'n', 'v'}, ';', 'l')

-- repeat previous f, t, F, T movement
vim.keymap.set('n', '\'', ';')

-- paste without overwriting
vim.keymap.set('v', 'p', 'P')

-- redo
vim.keymap.set('n', 'U', '<C-r>')

-- clear search highlight
vim.keymap.set('n', '<Esc>', '<CMD>nohlsearch<cr>', {
    silent = true
})

-- sync system clipboard
vim.opt.clipboard = 'unnamedplus'

-- search ignore case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- toggle relative line numbering
vim.keymap.set('n', '<leader>ln', ':set relativenumber!<cr>')

-- void change
vim.keymap.set('n', 'c', '"_c', {
    noremap = true
})
vim.keymap.set('n', 'x', '"_x', {
    noremap = true
})

-- yank all
vim.keymap.set('n', '<leader>ya', 'ggyG')

-- visual all
vim.keymap.set('n', '<leader>va', 'ggVG')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{'Failed to clone lazy.nvim:\n', 'ErrorMsg'}, {out, 'WarningMsg'},
                           {'\nPress any key to exit...'}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({{
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = is_vscode,
    opts = {}
}, {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {{
        "s",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump()
        end,
        desc = "Flash"
    }, {
        "S",
        mode = {"n", "x", "o"},
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter"
    }, {
        "r",
        mode = "o",
        function()
            require("flash").remote()
        end,
        desc = "Remote Flash"
    }, {
        "R",
        mode = {"o", "x"},
        function()
            require("flash").treesitter_search()
        end,
        desc = "Treesitter Search"
    }, {
        "<c-s>",
        mode = {"c"},
        function()
            require("flash").toggle()
        end,
        desc = "Toggle Flash Search"
    }}
}, {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
}})

if is_vscode then
    -- vscode-multi-cursor
    vim.api.nvim_set_hl(0, 'VSCodeCursor', {
        bg = '#542fa4',
        fg = 'white',
        default = true
    })

    vim.api.nvim_set_hl(0, 'VSCodeCursorRange', {
        bg = '#542fa4',
        fg = 'white',
        default = true
    })

    local cursors = require('vscode-multi-cursor')

    vim.keymap.set({'n', 'x', 'i'}, '<c-y>', function()
        cursors.addSelectionToNextFindMatch()
    end)

    vim.keymap.set({'n', 'x', 'i'}, '<cs-y>', function()
        cursors.addSelectionToPreviousFindMatch()
    end)

    vim.keymap.set({'n', 'x', 'i'}, '<cs-o>', function()
        cursors.selectHighlights()
    end)

    vim.keymap.set('n', 'mcm', cursors.cancel)
    vim.keymap.set('n', '<c-y>', 'mciw*:nohl<cr>', {
        remap = true
    })

    local vscode = require("vscode")

    vim.keymap.set('n', '<leader>cr', function()
        vscode.call("editor.action.rename")
    end)
    vim.keymap.set('n', '<leader>ca', function()
        vscode.call("editor.action.codeAction")
    end)
    vim.keymap.set('n', '<leader>cs', function()
        vscode.call("workbench.action.gotoSymbol")
    end)
    -- buggy
    -- vim.keymap.set({'n', 'v'}, 'J', function()
    -- vscode.call("editor.action.moveLinesUpAction")
    -- end)
    -- vim.keymap.set({'n', 'v'}, 'K', function()
    --     vscode.call("editor.action.moveLinesDownAction")
    -- end)
    vim.keymap.set('n', '<leader>d', function()
        vscode.call("workbench.action.closeActiveEditor")
    end)
    vim.keymap.set('n', '<leader>,', function()
        vscode.call("workbench.action.showAllEditors")
    end)
    vim.keymap.set('n', '<leader>fs', function()
        vscode.call("workbench.action.findInFiles")
    end)
    vim.keymap.set('n', '<leader>fe', function()
        vscode.call("workbench.action.focusActiveEditorGroup")
    end)
    vim.keymap.set('n', '<leader>ff', function()
        vscode.call("workbench.files.action.focusFilesExplorer")
    end)
    vim.keymap.set('n', '<leader>ft', function()
        vscode.call("workbench.action.terminal.focus")
    end)
    vim.keymap.set('n', '<leader>fx', function()
        vscode.call("workbench.view.extensions")
    end)
    vim.keymap.set('n', '<leader>fb', function()
        vscode.call("workbench.action.focusSideBar")
    end)
    vim.keymap.set('n', '<leader>ro', function()
        vscode.call("workbench.action.reopenClosedEditor")
    end)
    vim.keymap.set('n', '<leader><leader>', function()
        vscode.call("workbench.action.quickOpen")
    end)
    vim.keymap.set('n', '<leader>rr', function()
        vscode.call("vscode-neovim.restart")
    end)
    vim.keymap.set('n', '<leader>sr', function()
        vscode.call("extension.updateCustomCSS")
        vscode.call("workbench.action.reloadWindow")
    end)
    vim.keymap.set('n', 'gr', function()
        vscode.call("editor.action.goToReferences")
    end)
    vim.keymap.set('n', '<leader>gc', function()
        vscode.call("workbench.scm.focus")
    end)
    vim.keymap.set('n', '<leader>gl', function()
        vscode.call("gitlens.views.scm.grouped.focus")
    end)
    vim.keymap.set('n', '<leader>wc', function()
        vscode.call("editor.action.dirtydiff.next")
    end)
    vim.keymap.set('n', '<leader>fo', function()
        vscode.call("diffEditor.switchSide")
    end)
    vim.keymap.set('n', '<leader>ot', function()
        vscode.call("vscode-wezterm.openTerminal")
    end)
    vim.keymap.set('n', '<leader>cn', function()
        vscode.call("notifications.clearAll")
    end)
    vim.keymap.set('n', 'gt', function()
        vscode.call("editor.action.goToTypeDefinition")
    end)
end

-- flash
vim.api.nvim_set_hl(0, 'FlashLabel', {
    bg = '#e11684',
    fg = 'white'
})

vim.api.nvim_set_hl(0, 'FlashMatch', {
    bg = '#7c634c',
    fg = 'white'
})

vim.api.nvim_set_hl(0, 'FlashCurrent', {
    bg = '#7c634c',
    fg = 'white'
})
