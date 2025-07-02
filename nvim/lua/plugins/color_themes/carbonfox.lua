return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    require("nightfox").setup({
      options = {
        -- Optional: tweak styles or enable transparency here
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic",
        },
        transparent = false, -- set to true if you want no background
      },
    })

    vim.cmd.colorscheme("carbonfox")
  end,
}

