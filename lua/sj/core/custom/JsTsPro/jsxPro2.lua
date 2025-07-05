-- 🔥 Auto JSX Refactor Helper for Neovim
-- 📁 Save this as: ~/.config/nvim/lua/custom/auto_paste_component.lua

local M = {}

-- Regex to detect clean, empty JSX component
local component_pattern = "const%s+(%w+)%s*=%s*%(%s*%)%s*=>%s*{%s*return%s*<div>%s*</div>%s*;}"

-- Main logic: after deletion, search recent files for empty component
function M.auto_paste_to_component()
	local clipboard = vim.fn.getreg("+")
	if clipboard == nil or clipboard == "" then
		print("📋 Clipboard is empty — nothing to paste.")
		return
	end

	-- Get last 3 edited files
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

				-- Find the line with `return <div></div>;`
				for lnum, line in ipairs(lines) do
					if line:match("return%s*<div>%s*</div>%s*;") then
						vim.api.nvim_win_set_cursor(0, { lnum, 0 })
						vim.cmd("normal! o") -- insert new line inside div
						vim.fn.setreg('"', clipboard) -- set default register
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

-- Visual mode mapping: yank + delete + paste to component
vim.keymap.set("v", "<leader>cp", function()
	vim.cmd('normal! "+y') -- yank selection to clipboard
	vim.cmd("normal! d") -- delete selection
	require("custom.auto_paste_component").auto_paste_to_component()
end, { desc = "Move selected JSX to recent component", noremap = true, silent = true })

return M
