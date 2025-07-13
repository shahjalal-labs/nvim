--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯

--p: ╭──────────── Block Start ────────────╮
local function copy_github_url()
	-- Get the origin URL from git config
	local handle = io.popen("git -C " .. vim.fn.getcwd() .. " config --get remote.origin.url")
	if not handle then
		print("Not a git repository or no origin remote")
		return
	end
	local url = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if url == "" then
		print("No remote origin URL found")
		return
	end

	-- Normalize URL: convert SSH to HTTPS or keep HTTPS
	local https_url
	if url:match("^git@") then
		-- Convert ssh: git@github.com:user/repo.git => https://github.com/user/repo
		https_url = url:gsub("^git@", "https://"):gsub(":", "/"):gsub("%.git$", "")
	else
		-- HTTPS url - remove trailing .git if any
		https_url = url:gsub("%.git$", "")
	end

	-- Copy to system clipboard (using vim.fn.setreg)
	vim.fn.setreg("+", https_url)
	print("Copied GitHub URL to clipboard: " .. https_url)
end

vim.keymap.set("n", "<leader>gy", copy_github_url, { desc = "Copy current repo GitHub URL" })
--p: ╰───────────── Block End ─────────────╯

--p: ╭──────────── Block Start ────────────╮
-- Open the current repository in the browser
vim.keymap.set("n", "<leader>gm", ":!gh repo view --web<CR>", { noremap = true, silent = true })
--p: ╰───────────── Block End ─────────────╯
--
--p: ╭──────────── Block Start ────────────╮
--[[ local function show_github_contrib_today()
	local date = os.date("%Y-%m-%d")
	local cmd = table.concat({
		"gh api graphql -f query='query { viewer { contributionsCollection { contributionCalendar { weeks { contributionDays { date contributionCount } } } } } }' | jq -r '.data.viewer.contributionsCollection.contributionCalendar.weeks[] | .contributionDays[] | select(.date == \""
			.. date
			.. '") | "📆 \\(.date): 🔥 \\(.contributionCount) contributions"\'',
	}, " ")

	vim.cmd("vsplit | terminal " .. cmd)
end

vim.keymap.set("n", "<leader>gg", show_github_contrib_today, {
	noremap = true,
	silent = true,
	desc = "📈 Show today's GitHub contributions",
}) ]]

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮
local function show_github_summary()
	local lines = {
		"📆 13-07-25 | 🕒 First Commit: 10:45 AM → 🕕 Last Commit: 01:56 PM → 🔥 35 contributions",
		"",
		"🗓️ Weekly Contribution Summary (before today ↓)",
		"",
		"12-07-25   🟠 30 contributions",
		"11-07-25   🟠 25 contributions",
		"10-07-25   🟠 20 contributions",
		"09-07-25   🟡 15 contributions",
		"08-07-25   🟡 10 contributions",
		"07-07-25   🟢 5 contributions",
		"06-07-25   ⚪ 0 contributions",
		"",
		"📦 Repos Created Today:",
		"- flavorbook (public)",
		"- gontobbo-client (private)",
		"",
		"🔢 Commits Per Repo:",
		"- gontobbo-server → 3 commits",
		"- gontobbo-client → 2 commits",
		"",
		"🚀 Pushed To:",
		"- gontobbo-server",
		"- gontobbo-client",
		"",
		"🔗 Open Pull Requests:",
		"- [gontobbo-server/#42] Improve webhook support",
		"- [gontobbo-client/#17] Fix payment handler bug",
	}

	-- Create floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = 80
	local height = #lines + 2
	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	}

	vim.api.nvim_open_win(buf, true, win_opts)
end

vim.keymap.set("n", "<leader>gg", show_github_summary, {
	noremap = true,
	silent = true,
	desc = "🧾 GitHub Daily Summary",
})
--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
