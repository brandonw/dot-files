return {
  {
    "sainnhe/gruvbox-material",
    version = "146f40fd42cbef30fed69b4ef51329aeeaceb909", -- change to explicit version once blink updates included
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
    opts = {
      options = {
        mode = "tabs",
      },
    },
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
    opts = {
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
    },
  },
  {
    "kylechui/nvim-surround",
    version = "v2.3.2",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    opts = {},
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
    version = "v0.13.1",
    lazy = false,

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- https://cmp.saghen.dev/configuration/keymap.html#default
        preset = "default",
      },
      appearance = {
        -- Set to "mono" for "Nerd Font Mono" or "normal" for "Nerd Font"
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono"
      },
      completion = {
        trigger = {
          prefetch_on_insert = false,
          show_in_snippet = false,
          show_on_keyword = false,
          show_on_trigger_character = false,
        },
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" }
  },

  {
    "folke/snacks.nvim",
    -- Not released yet, but will include required fixes once released.
    -- Otherwise, will fail to find tag and default to `nil`.
    version = "v2.22.0",
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
        animate = {
          style = "out",
          easing = "linear",
          duration = {
            step = 20, -- ms per step
            total = 100, -- maximum duration
          },
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
