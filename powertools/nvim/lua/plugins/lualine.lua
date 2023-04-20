require('lualine').setup {
  options = {
    themes='kanagawa',
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 0,
        symbols = {
          readonly = '[RO]',
        }
      }
    },
    lualine_x = {},
    lualine_y = {'branch'},
    lualine_z = {'%l:%c', '%p%%'}
  }
}
