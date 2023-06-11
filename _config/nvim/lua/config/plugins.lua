return {
  {
    "sainnhe/gruvbox-material",
    lazy = false, -- make sure we load this during startup as it is our main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.opt.background = "dark"
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "lambdalisue/suda.vim",
    event = "VeryLazy",
    config = function ()
      vim.g["suda#prompt"] = "[sudo] password for brandon: "
      vim.cmd("cmap w!! w suda://%")
    end,
  },
  {
    "hashivim/vim-terraform",
    event = "VeryLazy",
  },
  {
    "cappyzawa/trim.nvim",
    event = "VeryLazy",
    config = function ()
      require('trim').setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function ()
      vim.opt.list = true
      vim.opt.listchars = {
        tab = "> ",
        -- eol = "↴",
        -- space = "⋅",
      }
      require("indent_blankline").setup({
          show_current_context = true,
          show_current_context_start = true,
      })
    end
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-fzf-native.nvim",
      "debugloop/telescope-undo.nvim",
    },
    keys = {
      {
        "gof",
        function ()
          require('telescope.builtin').git_files({
            show_untracked = true,
          })
        end,
        mode = "n",
      },
      {
        "gob",
        function ()
          require('telescope.builtin').buffers()
        end,
        mode = "n",
      },
      {
        "<Leader>h",
        function ()
          require('telescope.builtin').help_tags()
        end,
        mode = "n",
      },
      {
        "<Leader>u",
        function ()
          require("telescope").extensions.undo.undo()
        end,
        mode = "n",
      },
    },
    config = function()
      require("plugins.telescope")
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "goe", function () require("oil").open() end, mode = "n" },
    },
    config = function ()
      require("oil").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
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
        view = {
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_horizontal",
            disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
            winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
          },
        },
        hooks = {
          view_opened = function(view)
            if (view:class():name() == "DiffView") then
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
    keys = {
      { "gfb", "<Cmd>Git blame<CR>", mode = "n" },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function ()
      require("plugins.lsp")
    end,
  },
  {
    "towolf/vim-helm",
    event = "VeryLazy",
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      {
        "David-Kunz/cmp-npm",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        config = function()
          require("cmp-npm").setup({
            ignore = {},
            only_semantic_versions = true,
          })
        end,
      },
    },
    config = function()
      require("plugins.cmp")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function ()
      require("plugins.lualine")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = { ":TSUpdate" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    config = function ()
      require("plugins.ts")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function ()
      require("lint").linters_by_ft = {
        javascript = {"eslint"},
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "haydenmeade/neotest-jest",
    },
    lazy = false,
    keys = {
      {
        "<Leader>tn",
        function ()
          require("neotest").run.run()
        end,
        mode = "n",
      },
      {
        "<Leader>tf",
        function ()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
      },
      {
        "<Leader>to",
        function ()
          require("neotest").output.open({ enter = true, short = false })
        end,
        mode = "n",
      },
      {
        "<Leader>tp",
        function ()
          require("neotest").output_panel.toggle()
        end,
        mode = "n",
      },
      {
        "<Leader>ts",
        function ()
          require("neotest").summary.toggle()
        end,
        mode = "n",
      },
    },
    config = function ()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm run test --",
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 30"
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        summary = {
          open = "botright vsplit | vertical resize 50"
        }
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
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
    end
  },
}
