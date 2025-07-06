local function generate_and_run_gh_commands()
	local repo = vim.fn.trim(vim.fn.system("gh repo view --json nameWithOwner --jq .nameWithOwner"))
	if repo == "" then
		vim.notify("Failed to get repo name with owner", vim.log.levels.ERROR)
		return
	end

	local readme_path = "README.md"
	local lines = {}

	local file = io.open(readme_path, "r")
	if not file then
		vim.notify("README.md not found in current dir", vim.log.levels.ERROR)
		return
	end

	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	-- Find description line (max 20 chars)
	local description = "Portfolio website"
	for _, line in ipairs(lines) do
		local desc = line:match("^#%s*(.+)$") or line:match("^##%s*(.+)$")
		if desc and #desc <= 20 then
			description = desc
			break
		end
	end

	-- Find homepage URL from Live Site table
	local homepage = ""
	for i, line in ipairs(lines) do
		if line:match("Live Site") then
			-- Next line after table header usually has url
			for j = i, math.min(i + 5, #lines) do
				local url = lines[j]:match("%[(http[^]]+)%]")
				if url then
					homepage = url
					break
				end
			end
			if homepage ~= "" then
				break
			end
		end
	end

	if homepage == "" then
		vim.notify("Live Site URL not found, using placeholder", vim.log.levels.WARN)
		homepage = "http://example.com"
	end

	-- Topics to add (hardcoded example)
	local topics = { "portfolio", "react", "tailwind", "vite" }

	-- Compose commands (no markdown, just plain commands)
	local cmds = {}
	table.insert(cmds, string.format('gh repo edit %s --description "%s" --homepage "%s"', repo, description, homepage))
	for _, topic in ipairs(topics) do
		table.insert(cmds, string.format("gh repo edit %s --add-topic %s", repo, topic))
	end

	-- Write commands to file
	local outpath = "ghAbout.md"
	local fd = io.open(outpath, "w")
	if not fd then
		vim.notify("Failed to write " .. outpath, vim.log.levels.ERROR)
		return
	end
	for _, c in ipairs(cmds) do
		fd:write(c .. "\n")
	end
	fd:close()

	-- Put commands in clipboard (uses vim.fn.setreg)
	vim.fn.setreg("+", table.concat(cmds, "\n"))

	-- Open the file in current buffer
	vim.cmd("edit " .. outpath)

	vim.notify("ghAbout.md created and commands copied to clipboard!", vim.log.levels.INFO)
end

-- Map to <leader>ge in normal mode
vim.api.nvim_set_keymap(
	"n",
	"<leader>ge",
	[[<cmd>lua generate_and_run_gh_commands()<CR>]],
	{ noremap = true, silent = true }
)
