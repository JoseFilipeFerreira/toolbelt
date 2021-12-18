local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
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
