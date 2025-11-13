-- Blog

-- Markdown plugins
vim.pack.add({
 {src = "https://github.com/MeanderingProgrammer/render-markdown.nvim"}
})
require("render-markdown").setup()


-- Handling my blog posts
local blog_path = "~/projects/spiperac.github.io"

function blog_new_post()
  vim.ui.input({ prompt = "Post title: " }, function(input)
    if input then
      local slug = input:gsub(" ", "_"):lower()
      local date = os.date("%Y-%m-%d")
      local filename = date .. "-" .. slug .. ".md"
      local full_path = blog_path .. "/content/posts/" .. filename

      if vim.fn.filereadable(full_path) == 0 then
        vim.cmd("edit " .. full_path)
      else
        print("File already exists: " .. full_path)
        vim.cmd("edit " .. full_path)
      end
    end
  end)
end

vim.keymap.set('n', '<leader>bn', blog_new_post)
