local function open_cname_url_dynamic()
	local cwd = vim.fn.getcwd()
	local filepath = cwd .. "/public/CNAME"

	local file = io.open(filepath, "r")
	if not file then
		print("❌ CNAME file not found in " .. filepath)
		return
	end

	local url = file:read("*l")
	file:close()

	if not url or url == "" then
		print("❌ URL not found in CNAME file.")
		return
	end

	local open_cmd = "/usr/bin/xdg-open"

	-- Build shell command string (quote url safely)
	local shell_cmd = string.format("%s '%s' >/dev/null 2>&1 &", open_cmd, url)

	-- Run the command asynchronously with 'sh -c'
	vim.fn.jobstart({ "sh", "-c", shell_cmd }, { detach = true })

	print("🌐 Opening URL: " .. url)
end

vim.api.nvim_set_keymap("n", "<leader>bb", "", {
	noremap = true,
	silent = true,
	callback = open_cname_url_dynamic,
})
