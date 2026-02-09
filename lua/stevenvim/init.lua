require('stevenvim.opts_and_keys')

require("lze").register_handlers(require('nixCatsUtils.lzUtils').for_cat)
require('lze').register_handlers(require('lzextras').lsp)

if nixCats('debug') then
    require('stevenvim.debug')
end
if nixCats('lint') then
    require('stevenvim.lint')
end
if nixCats('format') then
    require('stevenvim.format')
end
