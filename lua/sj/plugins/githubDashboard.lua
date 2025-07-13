return {
	"juansalvatore/git-dashboard-nvim",
	lazy = true,
	keys = {
		{
			"<leader>gg",
			function()
				require("git-dashboard").open()
			end,
			desc = "📋 Git Dashboard",
		},
	},
	cmd = {
		"GitDashboard",
	},
	config = function()
		vim.api.nvim_create_user_command("GitDashboard", function()
			require("git-dashboard").open()
		end, {})
	end,
}
