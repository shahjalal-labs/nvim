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

	-- Prepend https:// if not present
	if not url:match("^https?://") then
		url = "https://" .. url
	end

	local open_cmd = string.format("xdg-open '%s'", url)

	-- Prompt for tmux pane number (auto fallback after 1.5s)
	local user_input = nil
	local done = false

	vim.defer_fn(function()
		if not done then
			local target_pane = user_input or "2"
			local tmux_cmd = string.format('tmux send-keys -t %s "%s" Enter', target_pane, open_cmd)
			os.execute(tmux_cmd)
			print("🌐 Sent to tmux pane " .. target_pane .. ": " .. url)
		end
	end, 1500)

	vim.schedule(function()
		user_input = vim.fn.input("📦 Send xdg-open to tmux pane [default: 2]: ")
		done = true
		local target_pane = user_input ~= "" and user_input or "2"
		local tmux_cmd = string.format('tmux send-keys -t %s "%s" Enter', target_pane, open_cmd)
		os.execute(tmux_cmd)
		print("🌐 Sent to tmux pane " .. target_pane .. ": " .. url)
	end)
end

vim.keymap.set("n", "<leader>bb", open_cname_url_dynamic, {
	noremap = true,
	silent = true,
	desc = "Open CNAME URL in browser (via tmux)",
})

----
---
---
--p: ╭──────────── Block Start ────────────╮
local function open_cname_url_direct()
	local cwd = vim.fn.getcwd()
	local filepath = cwd .. "/public/CNAME"

	local file = io.open(filepath, "r")
	if not file then
		vim.notify("❌ CNAME file not found in " .. filepath, vim.log.levels.ERROR)
		return
	end

	local url = file:read("*l")
	file:close()

	if not url or url == "" then
		vim.notify("❌ URL not found in CNAME file.", vim.log.levels.ERROR)
		return
	end

	-- Prepend https:// if missing
	if not url:match("^https?://") then
		url = "https://" .. url
	end

	local open_cmd = string.format("xdg-open '%s' >/dev/null 2>&1 &", url)
	os.execute(open_cmd)

	vim.notify("🌐 Opening in browser: " .. url, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>bc", open_cname_url_direct, {
	noremap = true,
	silent = true,
	desc = "Directly open CNAME URL in browser",
})

--p: ╰───────────── Block End ─────────────╯
