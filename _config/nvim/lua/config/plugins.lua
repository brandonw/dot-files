return {
  {
    "sainnhe/gruvbox-material",
    version = "1aa1842d80a8845842b9340df2d93683d667247b", -- change to explicit version once blink updates included
    lazy = false, -- make sure we load this during startup as it is our main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function ()
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.opt.background = "dark"
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  -- If I don"t notice this is gone, delete it for good
  -- { "tpope/vim-repeat", event = "VeryLazy", version = nil },
  {
    "lambdalisue/suda.vim",
    version = "v1.2.4",
    event = "VeryLazy",
    config = function ()
      vim.g["suda#prompt"] = "[sudo] password for brandon: "
      vim.cmd("cmap w!! w suda://%")
    end,
  },
  {
    "hashivim/vim-terraform",
    version = nil,
    event = "VeryLazy",
  },
  {
    "cappyzawa/trim.nvim",
    version = "v0.10.2",
    event = "VeryLazy",
    config = function ()
      require("trim").setup()
    end,
  },
  {
    "mangelozzi/rgflow.nvim",
    version = nil,
    event = "VeryLazy",
    config = function ()
      require("rgflow").setup({
        default_ui_mappings = true,
        default_quickfix_mappings = true,
        incsearch_after = false,
        quickfix = {
          open_qf_cmd_or_func = "botright copen", -- Open the quickfix window across the full bottom edge
        },
        cmd_flags = ("--fixed-strings --no-fixed-strings --no-ignore --ignore"
          .. " -g !tests"
          .. " -g !test"
          .. " -g !\\*.test.js"
          .. " -g !\\*.test.js.snap"
        ),
        mappings = {
          trigger = {
              n = {
                  ["gs"] = "open_cword",
              },
              -- Visual/select mode maps
              x = {
                  ["gs"] = "open_visual", -- Open UI - search pattern = current visual selection
              },
          },
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    version = nil,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      { "gfh", "<Cmd>DiffviewFileHistory %<CR>", mode = "n" },
      { "gq", "<Cmd>DiffviewClose<CR>", mode = "n" },
    },
    config = function()
      local diffview = require("diffview")
      local actions = require("diffview.config").actions
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ":h diffview-config-view.x.winbar_info"
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_mixed",
            disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
            winbar_info = true,           -- See ":h diffview-config-view.x.winbar_info"
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ":h diffview-config-view.x.winbar_info"
          },
        },
        hooks = {
          view_opened = function(view)
            if (view.class:name() == "DiffView") then
              -- Close DiffView:FilePanel initially
              actions.toggle_files()
            end
          end,
        }
      })
      vim.api.nvim_set_keymap("n", "gfd", ":DiffviewOpen  -- %<Left><Left><Left><Left><Left>", {})
    end,
  },
  {
    "tpope/vim-fugitive",
    version = nil, -- lots of commits after latest version (2+ years old)
    keys = {
      { "gfb", "<Cmd>Git blame<CR>", mode = "n" },
    },
  },
  {
    "towolf/vim-helm",
    version = nil,
    event = "VeryLazy",
  },
  {
    "akinsho/bufferline.nvim",
    version = "v4.9.1",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function ()
      require("bufferline").setup({
        options = {
          mode = "tabs",
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    version = nil,
    event = "VeryLazy",
    config = function ()
      require("plugins.lint")
    end,
  },

  -- treesitter
  {
    "nvim-lualine/lualine.nvim",
    version = nil,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function ()
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff", "diagnostics"},
          lualine_c = {
            {
              "filename",
              path = 1,
            }
          },
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {"progress"},
          lualine_z = {"location"}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {"filename"},
          lualine_x = {"location"},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "v2.3.2",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = "v0.9.3",
    build = { ":TSUpdate" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    config = function ()
      require("plugins.treesitter")
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    version = "v1.6.0",
    dependencies = {
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    event = "BufReadPre",
    config = function ()
      require("plugins.lsp")
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.11.0",
    lazy = false,

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- https://cmp.saghen.dev/configuration/keymap.html#default
      keymap = { preset = "default" },
      appearance = {
        -- Set to "mono" for "Nerd Font Mono" or "normal" for "Nerd Font"
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono"
      },

      completion = {
        trigger = {
          -- show_on_keyword = false,
          -- show_on_trigger_character = false,
          -- show_on_insert_on_trigger_character = false,
          -- show_on_accept_on_trigger_character = false,
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" }
  },

  {
    "folke/snacks.nvim",
    version = "v2.20.0",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {
        enabled = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 6, total = 100 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 2, total = 25 },
          easing = "linear",
        },
      },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      indent = {
        enableed = true,
        priority = 1,
        chunk = {
          enabled = true,
        },
        only_scope = false,
      },
      scope = {
        enabled = true,
      },
      toggle = {
        enabled = true,
      },
      picker = {
        enabled = true,
        sources = {
          explorer = {},
          git_files = {
            untracked = true,
          },
        },
        jump = {
          reuse_win = true,
        },
        win = {
          input = {
            keys = {
              ["<C-t>"] = { "edit_tab", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-t>"] = { "edit_tab", mode = { "i", "n" } },
            },
          }
        },
      },
    },
    keys = {
      -- Explorer
      -- Switch to this when available
      -- { "goe", function () Snacks.explorer.reveal() end, desc = "Open Explorer" },
      { "goe", function () Snacks.explorer.open() end, desc = "Open Explorer" },
      { "gof", function () Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "gob", function () Snacks.picker.buffers() end, desc = "Buffers" },
      { "<Leader>gb", function () Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<Leader>h", function () Snacks.picker.help() end, desc = "Help Pages" },
      { "<Leader>u", function () Snacks.picker.undo() end, desc = "Undo History" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("hlsearch", { name = "Highlight Search" }):map("yoh")
        end,
      })
    end,
  },

  -- dependencies with no configuration
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    version = nil,
  },
  {
    "rafamadriz/friendly-snippets",
    version = nil,
  },
  {
    "nvim-tree/nvim-web-devicons",
    version = nil,
  },
  {
    "b0o/SchemaStore.nvim",
    version = nil,
  },
  {
    "nvim-lua/plenary.nvim",
    version = nil, -- tags do not seem to fully track releases?
  },
}
-- TODO:
-- snacks picker new tab crash
-- try out folds
