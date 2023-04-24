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
    "junegunn/fzf",
    keys = {
      { "gof", "<cmd>FZF<cr>", mode = "n" },
    },
  },
  {
    "hashivim/vim-terraform",
    event = "VeryLazy",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>u", "<cmd>Telescope undo<cr>", mode = "n" },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          undo = {},
        },
      })
      require("telescope").load_extension("undo")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
      { "<leader>f", "<cmd>Neotree float<cr>", mode = "n" },
    },
    config = function ()
      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "open_current",
        }
      })
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
      { "<leader>h", "<cmd>DiffviewFileHistory %<cr>", mode = "n" },
    },
    config = function()
      require("diffview").setup()
      vim.api.nvim_set_keymap('n', '<leader>d', ':DiffviewOpen ', {})
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require('Comment').setup()
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
          require('cmp-npm').setup({
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
        "<leader>tn",
        function ()
          require("neotest").run.run()
        end,
        mode = "n",
      },
      {
        "<leader>tf",
        function ()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
      },
      {
        "<leader>to",
        function ()
          require("neotest").output.open({ enter = true, short = false })
        end,
        mode = "n",
      },
      {
        "<leader>tp",
        function ()
          require("neotest").output_panel.toggle()
        end,
        mode = "n",
      },
      {
        "<leader>ts",
        function ()
          require("neotest").summary.toggle()
        end,
        mode = "n",
      },
    },
    config = function ()
      require("neotest").setup({
        adapters = {
          require('neotest-jest')({
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
}
