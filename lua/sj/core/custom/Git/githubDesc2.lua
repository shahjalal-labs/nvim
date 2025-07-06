local M = {}

local function notify(msg, level)
	vim.schedule(function()
		vim.notify(msg, level or vim.log.levels.INFO)
	end)
end

local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function shorten_desc(desc)
	desc = desc:gsub("\n", " ") -- replace newlines with space
	if #desc > 20 then
		return desc:sub(1, 20)
	else
		return desc
	end
end

local function extract_repo_url(lines)
	for _, line in ipairs(lines) do
		local repo = line:match("%[.*%]%((https://github.com/[%w-_]+/[%w-_]+)%)")
		if repo then
			return repo
		end
	end
	return nil
end

local function extract_live_site(lines)
	for i, line in ipairs(lines) do
		if line:lower():match("live site") then
			-- next lines might contain URL in markdown link format
			for j = i, math.min(i + 3, #lines) do
				local url = lines[j]:match("%((https?://[^%)]+)%)")
				if url then
					return url
				end
			end
		end
	end
	return nil
end

local function extract_description(lines)
	-- Take first non-empty line after first header (# )
	local found_header = false
	for _, line in ipairs(lines) do
		if line:match("^# ") then
			found_header = true
		elseif found_header and line:match("%S") then
			return trim(line)
		end
	end
	return "No description"
end

function M.generate_and_run_gh_commands()
	notify("Starting GitHub About update...")

	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local repo_url = extract_repo_url(buf_lines)
	if not repo_url then
		notify("Failed: Could not find GitHub repo URL in README.", vim.log.levels.ERROR)
		return
	end

	local repo_path = repo_url:gsub("https://github.com/", "")

	local live_site = extract_live_site(buf_lines) or ""

	local description = extract_description(buf_lines)
	description = shorten_desc(description)

	-- Build commands
	local cmds = {}

	-- Description and homepage
	table.insert(
		cmds,
		string.format('gh repo edit %s --description "%s" --homepage "%s"', repo_path, description, live_site)
	)

	-- Extract topics (just an example, if you want dynamic topic extraction, add here)
	-- For demo, adding common topics:
	local topics = { "portfolio", "react", "tailwind", "vite" }
	for _, topic in ipairs(topics) do
		table.insert(cmds, string.format("gh repo edit %s --add-topic %s", repo_path, topic))
	end

	local content = table.concat(cmds, "\n")

	-- Write to file ghCommands.md
	local fname = vim.fn.getcwd() .. "/ghCommands.md"
	local fd = io.open(fname, "w")
	if not fd then
		notify("Failed to write to " .. fname, vim.log.levels.ERROR)
		return
	end
	fd:write(content)
	fd:close()

	-- Copy to clipboard
	vim.fn.setreg("+", content)

	-- Open file in new buffer
	vim.cmd("edit " .. fname)

	-- Run commands internally
	local success = true
	for _, cmd in ipairs(cmds) do
		local handle = io.popen(cmd .. " 2>&1")
		if not handle then
			notify("Failed to run command: " .. cmd, vim.log.levels.ERROR)
			success = false
			break
		end
		local result = handle:read("*a")
		local ok, _, exit_code = handle:close()
		if not ok or exit_code ~= 0 then
			-- Write errors to file (append)
			local fderr = io.open(fname, "a")
			if fderr then
				fderr:write("\n\n# Command failed:\n")
				fderr:write(cmd .. "\n\n")
				fderr:write(result .. "\n")
				fderr:close()
			end
			notify("Error running command: " .. cmd .. "\nSee ghCommands.md for details.", vim.log.levels.ERROR)
			success = false
			break
		end
	end

	if success then
		notify("GitHub About updated successfully! Commands copied to clipboard and opened in ghCommands.md.")
	end
end

-- Keybind setup
vim.api.nvim_set_keymap(
	"n",
	"<leader>ge",
	[[<cmd>lua require('githubDescription').generate_and_run_gh_commands()<CR>]],
	{ noremap = true, silent = true }
)

return M
