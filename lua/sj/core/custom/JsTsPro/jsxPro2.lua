local M = {}

-- Regex to find empty JSX component
local component_pattern = "const%s+(%w+)%s*=%s*%(%s*%)%s*=>%s*{%s*return%s*<div>%s*</div>%s*;}"

-- Main function to scan last few files and paste into JSX
function M.auto_paste_to_component()
	local clipboard = vim.fn.getreg("+")
	if clipboard == nil or clipboard == "" then
		print("📋 Clipboard is empty — nothing to paste.")
		return
	end

	-- Get list of recently opened files (or use vim.v.oldfiles)
	local recent_files = vim.v.oldfiles
	local max_files = math.min(3, #recent_files)

	for i = 1, max_files do
		local file = recent_files[i]
		if file:match("%.jsx$") or file:match("%.tsx$") then
			local lines = vim.fn.readfile(file)
			local content = table.concat(lines, "\n")

			local component_name = content:match(component_pattern)
			if component_name then
				print("✅ Found component: " .. component_name .. " in file: " .. file)

				-- Open the file
				vim.cmd("edit " .. file)

				-- Find the return <div></div>; line
				for lnum, line in ipairs(lines) do
					if line:match("return%s*<div>%s*</div>%s*;") then
						vim.api.nvim_win_set_cursor(0, { lnum, 0 })
						vim.cmd("normal! o") -- create new line inside div
						vim.fn.setreg('"', clipboard) -- paste from clipboard
						vim.cmd('normal! ""p')
						vim.cmd("write")
						return
					end
				end
			end
		end
	end

	print("❌ No matching empty component found in recent files.")
end

return M
