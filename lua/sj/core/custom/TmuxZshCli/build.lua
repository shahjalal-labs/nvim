--[[ local function open_cname_url_dynamic()
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
}) ]]

----
---
---
--p: ╭──────────── Block Start ────────────╮
--w: open url in browser from CNAME
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
--
--p: ╭──────────── Block Start ────────────╮
--w: build, cp and browser open the buld project
local function BuildCopyOpenInTmux()
	local cwd = vim.fn.getcwd()
	local cname_path = cwd .. "/public/CNAME"

	local file = io.open(cname_path, "r")
	if not file then
		vim.notify("❌ CNAME file not found in " .. cname_path, vim.log.levels.ERROR)
		return
	end

	local url = file:read("*l")
	file:close()

	if not url or url == "" then
		vim.notify("❌ CNAME file is empty.", vim.log.levels.ERROR)
		return
	end

	if not url:match("^https?://") then
		url = "https://" .. url
	end

	local build_cmd = string.format("bun run build && cp dist/index.html dist/200.html && xdg-open '%s'", url)
	local user_input = nil
	local done = false

	-- Fallback if no input is given within 1000ms
	vim.defer_fn(function()
		if not done then
			local fallback_pane = "2"
			local tmux_cmd = string.format('tmux send-keys -t %s "%s" Enter', fallback_pane, build_cmd)
			os.execute(tmux_cmd)
			vim.notify("🕒 Timeout: Sent to tmux pane 2 by default.", vim.log.levels.WARN)
			done = true
		end
	end, 1000)

	-- Prompt for pane input
	vim.schedule(function()
		user_input = vim.fn.input("📦 Enter tmux pane number (default: 2): ")
		if not done then
			local pane = (user_input ~= "" and user_input) or "2"
			local tmux_cmd = string.format('tmux send-keys -t %s "%s" Enter', pane, build_cmd)
			os.execute(tmux_cmd)
			vim.notify("🚀 Sent to tmux pane " .. pane .. ": Build + Open", vim.log.levels.INFO)
			done = true
		end
	end)
end

vim.keymap.set("n", "<leader>bo", BuildCopyOpenInTmux, {
	noremap = true,
	silent = true,
	desc = "Build + copy + open in tmux pane",
})
--p: ╰───────────── Block End ─────────────╯
