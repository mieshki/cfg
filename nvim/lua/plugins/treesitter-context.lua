-- File: nvim/lua/plugins/treesitter-context.lua
return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- Load on buffer read so context is available when you open files
	event = "BufReadPost",
	opts = {
		enable = true, -- Enable this plugin
		throttle = true, -- Throttle updates (good for performance)
		max_lines = 0, -- No limit on how many lines the window shows
		patterns = {
			default = {
				"class",
				"function",
				"method",
				"for",
				"if",
				"switch",
				"case",
			},
			rust = { "impl_item", "struct", "enum" }, -- Rust-specific
			-- add other filetypes here if you like
		},
	},
	config = function(_, opts)
		require("treesitter-context").setup(opts)
	end,
}
