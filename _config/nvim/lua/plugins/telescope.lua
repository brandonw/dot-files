local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                        -- the default case_mode is "smart_case"
    },
    undo = {},
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["x"] = actions.delete_buffer,
        }
      }
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
})

telescope.load_extension("fzf")
telescope.load_extension("undo")
