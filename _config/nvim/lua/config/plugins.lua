return {
  ------------------------------------------------
  -- generic dependencies with no configuration --
  ------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
  },
  {
    "nvim-lua/plenary.nvim",
    branch = "master", -- tags do not seem to fully track releases?
  },
  {
    -- for ramilito/kubectl.nvim
    "saghen/blink.download",
    branch = "main",
  },

  -------------------------------------------
  -- plugins that are reasonably hands-off --
  -------------------------------------------
  {
    "sainnhe/gruvbox-material",
    branch = "master", -- change to explicit version once blink updates included
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
    branch = "master",
    event = "VeryLazy",
  },
  {
    "cappyzawa/trim.nvim",
    version = "v0.10.2",
    event = "VeryLazy",
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    branch = "main",
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
    branch = "master", -- lots of commits after latest version (2+ years old)
    keys = {
      { "gfb", "<Cmd>Git blame<CR>", mode = "n" },
    },
  },
  {
    "towolf/vim-helm",
    branch = "master",
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
    branch = "master",
    event = "VeryLazy",
    config = function ()
      require("plugins.lint")
    end,
  },
  {
    "stevearc/conform.nvim",
    version = "v9.0.0",
    event = { "VeryLazy" },
    keys = {
      {
        "<Leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        json = { "prettier", stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = { timeout_ms = 500 },
      log_level = vim.log.levels.DEBUG
    },
  },

  -----------
  --- k8s ---
  -----------
  {
    "ramilito/kubectl.nvim",
    version = "2.9.4",
    dependencies = "saghen/blink.download",
    opts = {},
    cmd = { "Kubectl" },
    keys = {
      { "gok", "<cmd>lua require('kubectl').toggle()<CR>" },

      -- { "1", "<Plug>(kubectl.view_deployments)", ft = "k8s_*" },
      -- { "2", "<Plug>(kubectl.view_replicasets)", ft = "k8s_*" },
      -- { "3", "<Plug>(kubectl.view_pods)", ft = "k8s_*" },
      -- { "4", "<Plug>(kubectl.view_nodes)", ft = "k8s_*" },
      -- { "5", "<Plug>(kubectl.view_events)", ft = "k8s_*" },
      -- { "6", "<Plug>(kubectl.view_horizontalpodautoscalers)", ft = "k8s_*" },
      -- { "7", "<Plug>(kubectl.view_horizontalpodautoscalers)", ft = "k8s_*" },
      --
      -- { "8", "<Plug>(kubectl.view_api_resources)", ft = "k8s_*" },
      -- { "9", "<Plug>(kubectl.view_overview)", ft = "k8s_*" },
    },
    config = function()
      require("kubectl").setup()
    end,
  },

  ---
  --------
  -- ai --
  --------

  ----------------
  -- treesitter --
  ----------------
  {
    "nvim-lualine/lualine.nvim",
    branch = "master",
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
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
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

  ----------------------------------------------------
  -- language server protocol, snippets, completion --
  ----------------------------------------------------
  {
    "b0o/SchemaStore.nvim",
    branch = "main",
  },
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
    "rafamadriz/friendly-snippets",
    branch = "main",
  },
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v1.0.0",
    lazy = false,

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        -- Set to "mono" for "Nerd Font Mono" or "normal" for "Nerd Font"
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono"
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        -- https://cmp.saghen.dev/configuration/keymap.html#default
        preset = "default",
      },
      signature = {
        enabled = true,
      },
    },
    opts_extend = { "sources.default" }
  },

  ---------------------------
  -- pickers, explorer, ux --
  ---------------------------
  {
    "folke/snacks.nvim",
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
      terminal = {
        enable = true,
      },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            layout = { preset = "ivy", layout = { position = "top" } },
            watch = false, -- remove if/when luv usage is fixed
          },
          git_files = {
            untracked = true,
          },
          files = {
            hidden = true,
          },
          buffers = {
            sort_lastused = false,
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
        formatters = {
          file = {
            -- Truncate the file path to (roughly) this length.
            -- Will not play well if you tile a new terminal in nvim's workspace
            -- after it has started.
            truncate = math.floor(vim.o.columns * 0.333),
          },
        },
      },
      styles = {
        terminal = {
          bo = {
            filetype = "snacks_terminal",
          },
          wo = {},
          keys = {
            q = "hide",
            gf = function(self)
              local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
              if f == "" then
                Snacks.notify.warn("No file under cursor")
              else
                self:hide()
                vim.schedule(function()
                  vim.cmd("e " .. f)
                end)
              end
            end,
            term_normal = {
              "<esc>",
              function(self)
                vim.cmd("stopinsert")
              end,
              mode = "t",
              expr = true,
              desc = "Escape to normal mode",
            },
          },
        }
      },
    },
    keys = {
      -- Explorer
      { "goe", function () Snacks.explorer.reveal() end, desc = "Open Explorer" },
      { "gof", function () Snacks.picker.files() end, desc = "Find Files" },
      { "goa", function () Snacks.picker.files({hidden = true, ignored = true}) end, desc = "Find All Files" },
      {
        -- Customized Find Files with a good preset based on the basename of cwd
        "god",
        function ()
          local basename = vim.fs.basename(vim.uv.cwd())
          if basename == "hightouch" then
            Snacks.picker.pick({ source = "files", cwd = "./packages/backend/", title = "packages/backend/ Files" })
          elseif basename == "passage-internal" then
            Snacks.picker.files({ exclude = { "vendor/**" } })
          elseif basename == "infra" then
            Snacks.picker.files({ exclude = { "cdktf.out/**", "vendor/**" } })
          else
            vim.notify("\"" .. basename .. "\" does not have a customized Find Files", vim.log.levels.WARN)
          end
        end,
        desc = "Find Backend Files",
      },
      { "gob", function () Snacks.picker.buffers() end, desc = "Buffers" },
      { "gom", function () Snacks.picker.marks() end, desc = "Marks" },
      { "gos", function () Snacks.picker.lsp_symbols() end, desc = "LSP document symbols" },
      { "got", function () Snacks.picker.treesitter() end, desc = "Treesitter symbols" },
      { "<Leader>gb", function () Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<Leader>h", function () Snacks.picker.help() end, desc = "Help Pages" },
      { "<Leader>u", function () Snacks.picker.undo() end, desc = "Undo History" },
    },
  },
}
