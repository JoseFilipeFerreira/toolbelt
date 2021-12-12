vim.g.mapleader=' '

local if_require_do = require('utils.misc').if_require_do

require('plugins')

mapx = if_require_do('mapx', function(m) m.setup { global = true, whichKey = true } end)
if not mapx then
    print('run :PackerSync for first time setup')
    return
end

require("behaviour")
require("keybinds")
require("navigation")
require("writing")
