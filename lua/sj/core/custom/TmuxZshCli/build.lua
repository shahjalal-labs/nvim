local function open_cname_url_dynamic()
	local cwd = vim.fn.getcwd()
	local filepath = cwd .. "public/CNAME"

	local file = io.open(filepath, "r")
	if not file then
		print("❌ CNAME file not found in " .. cwd)
		return
	end

	local url = file:read("*l")
	file:close()

	if not url or url == "" then
		print("❌ URL not found in CNAME file.")
		return
	end

	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	else
		print("❌ Unsupported OS for opening URL.")
		return
	end

	vim.fn.jobstart({ open_cmd, url }, { detach = true })
	print("🌐 Opening URL: " .. url)
end

-- Map to <leader>bb using an anonymous function calling your local function
vim.api.nvim_set_keymap("n", "<leader>bb", "", {
	noremap = true,
	silent = true,
	callback = open_cname_url_dynamic,
})
