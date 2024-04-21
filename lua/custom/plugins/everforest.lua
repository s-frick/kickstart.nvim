return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,

  config = function()
    local everforest = require 'everforest'
    everforest.setup {
      background = 'hard',
      italics = true,
      disable_italic_comments = true,
    }
    everforest.load()
  end,
  -- init = function()
  --   -- Load the colorscheme here.
  --   -- Like many other themes, this one has different styles, and you could load
  --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --   vim.cmd.colorscheme 'everforest'
  -- end,
}
