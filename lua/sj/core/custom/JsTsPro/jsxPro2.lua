local function auto_paste_to_component()
	local clipboard = vim.fn.getreg("+")
	if clipboard == nil or clipboard == "" then
		vim.notify("📋 Clipboard empty — skipping paste.", vim.log.levels.WARN)
		return
	end

	local component_pattern = "const%s+(%w+)%s*=%s*%(%s*%)%s*=>%s*{"

	local recent_files = vim.v.oldfiles
	local max_files = math.min(3, #recent_files)

	for i = 1, max_files do
		local file = recent_files[i]
		if file:match("%.jsx$") or file:match("%.tsx$") then
			local lines = vim.fn.readfile(file)
			local content = table.concat(lines, "\n")

			local component_name = content:match(component_pattern)
			if component_name then
				vim.notify("✅ Found component: " .. component_name, vim.log.levels.INFO)
				vim.cmd("edit " .. file)

				-- single-line <div></div>
				for lnum, line in ipairs(lines) do
					if line:match("return%s*<div>%s*</div>%s*;") then
						vim.api.nvim_win_set_cursor(0, { lnum, 0 })
						vim.cmd("normal! o")
						vim.fn.setreg('"', clipboard)
						vim.cmd('normal! ""p')
						vim.cmd("write")
						return
					end
				end

				-- multiline return (
				for lnum = 1, #lines - 4 do
					if
						lines[lnum]:match("^%s*return%s*%(%s*$")
						and lines[lnum + 1]:match("^%s*<div>%s*$")
						and lines[lnum + 3]:match("^%s*</div>%s*$")
						and lines[lnum + 4]:match("^%s*%)%s*;?%s*$")
					then
						vim.api.nvim_win_set_cursor(0, { lnum + 2, 0 })
						vim.cmd("normal! o")
						vim.fn.setreg('"', clipboard)
						vim.cmd('normal! ""p')
						vim.cmd("write")
						return
					end
				end
			end
		end
	end

	vim.notify("❌ No valid empty component found.", vim.log.levels.WARN)
end

-- Wrapper function with delay
local function delayed_paste()
	vim.defer_fn(function()
		auto_paste_to_component()
	end, 400) -- 400 ms delay
end

-- Map dat and dst to run original command then delayed paste
vim.keymap.set({ "n", "x" }, "dat", function()
	vim.cmd("normal! dat")
	delayed_paste()
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, "dst", function()
	vim.cmd("normal! dst")
	delayed_paste()
end, { noremap = true, silent = true })

-- Visual mode mapping <leader>cp remains same
vim.keymap.set("v", "<leader>cp", function()
	vim.cmd('normal! "+y')
	vim.cmd("normal! d")
	delayed_paste()
end, { desc = "Move selected JSX to last created component", noremap = true, silent = true })
