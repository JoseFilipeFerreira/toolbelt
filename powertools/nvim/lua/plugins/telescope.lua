local actions = require('telescope.actions')

local ignore = {
  '.git/.*',
  'lib',
  'build',
  '%.svg',
  '%.png',
  '%.jpeg',
  '%.jpg',
  '%.tif',
  '%.ico',
  '%.rar',
}

require('telescope').setup {
    defaults = {
        file_ignore_patterns = ignore,
        previewer = true,
        mappings = {
            n = {
                ["q"] = actions.close
            },
            i = {
                ["<C-d>"] = actions.close
            }
        }
    }
}

