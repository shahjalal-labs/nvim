-- JSX Clipboard Auto-Paste for single-line or multiline empty <div>
-- Paste into your init.lua or keymaps.lua

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

				-- First try single-line return <div></div>;
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

				-- Then try multiline pattern
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

	vim.notify("❌ No valid empty component with empty <div> found in recent files.", vim.log.levels.WARN)
end

-- Visual mode mapping: <leader>cp
vim.keymap.set("v", "<leader>cp", function()
	vim.cmd('normal! "+y') -- yank visual selection to clipboard
	vim.cmd("normal! d") -- delete selection
	auto_paste_to_component()
end, { desc = "Move selected JSX to last created component", noremap = true, silent = true })

-- Optional autocmd to watch for deletes and auto-paste
vim.api.nvim_create_autocmd("TextChanged", {
	pattern = "*",
	callback = function()
		local reg = vim.fn.getreg("+")
		if reg and reg:match("</%w") then
			vim.defer_fn(function()
				auto_paste_to_component()
			end, 100)
		end
	end,
})
