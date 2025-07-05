local last_component_file = nil
local last_cursor_pos = nil

local function auto_paste_to_component()
	local clipboard = vim.fn.getreg("+")
	if clipboard == nil or clipboard == "" then
		vim.notify("📋 Clipboard empty — skipping paste.", vim.log.levels.WARN)
		return false
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
				vim.cmd("edit " .. file)

				-- Check single-line <div></div>
				for lnum, line in ipairs(lines) do
					if line:match("^%s*return%s*<div>%s*</div>%s*;") then
						local indent = line:match("^(%s*)return") or ""
						local new_lines = {
							indent .. "return (",
							indent .. "  <div>",
						}
						for clip_line in clipboard:gmatch("[^\r\n]+") do
							table.insert(new_lines, indent .. "    " .. clip_line)
						end
						table.insert(new_lines, indent .. "  </div>")
						table.insert(new_lines, indent .. ");")

						vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, new_lines)
						vim.api.nvim_win_set_cursor(0, { lnum + 2, 0 })
						vim.cmd("write")
						last_component_file = file
						last_cursor_pos = { lnum + 2, 0 }
						return true
					end
				end

				-- Check multi-line JSX return
				for lnum = 1, #lines - 4 do
					if
						lines[lnum]:match("^%s*return%s*%(%s*$")
						and lines[lnum + 1]:match("^%s*<div>%s*$")
						and lines[lnum + 3]:match("^%s*</div>%s*$")
						and lines[lnum + 4]:match("^%s*%)%s*;?%s*$")
					then
						local indent = lines[lnum + 1]:match("^(%s*)<div>") or ""
						local clip_lines = {}
						for clip_line in clipboard:gmatch("[^\r\n]+") do
							table.insert(clip_lines, indent .. "  " .. clip_line)
						end

						vim.api.nvim_buf_set_lines(0, lnum + 1, lnum + 1, false, clip_lines)
						vim.api.nvim_win_set_cursor(0, { lnum + 2, 0 })
						vim.cmd("write")
						last_component_file = file
						last_cursor_pos = { lnum + 2, 0 }
						return true
					end
				end
			end
		end
	end

	vim.notify("❌ No valid empty component found.", vim.log.levels.WARN)
	return false
end

local function visual_cp_paste_to_component()
	-- 1. Delete selection and yank to clipboard
	vim.cmd([[normal! "+d]])

	-- 2. Delay to give clipboard time to update, then paste
	vim.defer_fn(function()
		local pasted = auto_paste_to_component()
		if pasted and last_component_file and last_cursor_pos then
			vim.defer_fn(function()
				vim.cmd("edit " .. last_component_file)
				vim.api.nvim_win_set_cursor(0, last_cursor_pos)
				vim.notify("🎯 JSX pasted and focus moved", vim.log.levels.INFO)
			end, 300)
		end
	end, 300)
end

-- ✅ Visual mode only: Cut selection, paste to component
vim.keymap.set("v", "<leader>cp", visual_cp_paste_to_component, {
	desc = "Cut JSX and move to last created component",
	noremap = true,
	silent = true,
})
