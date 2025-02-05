return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

      require("lualine").setup({
        icons_enabled = true,
        options = {
          theme = 'dracula',
          component_separators = ' ', -- Remove component separators
          section_separators = ' ',   -- Remove section separators
        },
      })
    end
  }
}
