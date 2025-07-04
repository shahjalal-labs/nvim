return {

	"okuuva/auto-save.nvim",
	version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
	cmd = "ASToggle", -- optional for lazy loading on command
	event = { "TextChanged" }, -- optional for lazy loading on trigger events
	opts = {
		-- your config goes here
		-- or just leave it empty :)
		debounce_delay = 295,
		-- trigger_events = { "TextChanged" },
	},
}
