-- Improved JSX paste into component:
-- Converts single-line `return <div></div>;` into multiline JSX return with pasted content inside <div>
-- Inserts clipboard properly inside existing multiline returns as well

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

				-- Search for single-line return <div></div>;
				for lnum, line in ipairs(lines) do
					if line:match("^%s*return%s*<div>%s*</div>%s*;") then
						-- Replace this single line with multiline JSX with clipboard inside <div>
						-- Construct new lines:
						local indent = line:match("^(%s*)return") or ""
						local new_lines = {
							indent .. "return (",
							indent .. "  <div>",
						}

						-- Insert clipboard content lines with extra indentation
						for clip_line in clipboard:gmatch("[^\r\n]+") do
							table.insert(new_lines, indent .. "    " .. clip_line)
						end

						table.insert(new_lines, indent .. "  </div>")
						table.insert(new_lines, indent .. ");")

						-- Replace the single line in buffer with these new lines
						vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, new_lines)
						-- Move cursor inside the pasted content line (first clipboard line)
						vim.api.nvim_win_set_cursor(0, { lnum + 2, 0 })
						vim.cmd("write")
						return
					end
				end

				-- Search for multiline return with empty <div> block
				for lnum = 1, #lines - 4 do
					if
						lines[lnum]:match("^%s*return%s*%(%s*$")
						and lines[lnum + 1]:match("^%s*<div>%s*$")
						and lines[lnum + 3]:match("^%s*</div>%s*$")
						and lines[lnum + 4]:match("^%s*%)%s*;?%s*$")
					then
						-- Insert clipboard lines inside <div> block (between lnum+1 and lnum+3)
						local indent = lines[lnum + 1]:match("^(%s*)<div>") or ""
						local clip_lines = {}
						for clip_line in clipboard:gmatch("[^\r\n]+") do
							table.insert(clip_lines, indent .. "  " .. clip_line)
						end

						-- Insert clip_lines after line lnum+1 (<div> line)
						vim.api.nvim_buf_set_lines(0, lnum + 1, lnum + 1, false, clip_lines)

						-- Move cursor to first pasted line
						vim.api.nvim_win_set_cursor(0, { lnum + 2, 0 })
						vim.cmd("write")
						return
					end
				end
			end
		end
	end

	vim.notify("❌ No valid empty component found.", vim.log.levels.WARN)
end

local function delayed_paste()
	vim.defer_fn(function()
		auto_paste_to_component()
	end, 400) -- 400 ms delay
end

-- Map dat: delete tag normally + delayed paste & switch to new component file
vim.keymap.set({ "n", "x" }, "dat", function()
	vim.cmd("normal! dat")
	delayed_paste()
end, { noremap = true, silent = true })

-- Map dst: delete tag normally only (no paste)
vim.keymap.set({ "n", "x" }, "dst", function()
	vim.cmd("normal! dst")
end, { noremap = true, silent = true })

-- Visual mode mapping <leader>cp:
vim.keymap.set("v", "<leader>cp", function()
	vim.cmd('normal! "+y')
	vim.cmd("normal! d")
	delayed_paste()
end, { desc = "Move selected JSX to last created component", noremap = true, silent = true })
