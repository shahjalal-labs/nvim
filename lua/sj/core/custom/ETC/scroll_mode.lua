-- ~/.config/nvim/lua/scroll_mode.lua

local M = {
	active = false,
}

-- Toggle scroll mode
function M.toggle()
	M.active = not M.active
	if M.active then
		vim.notify("Scroll Mode: ON", vim.log.levels.INFO)
	else
		vim.notify("Scroll Mode: OFF", vim.log.levels.INFO)
	end
end

-- Scroll down 10 lines
function M.scroll_down()
	if M.active then
		vim.cmd("normal! 10j")
	end
end

-- Scroll up 10 lines
function M.scroll_up()
	if M.active then
		vim.cmd("normal! 10k")
	end
end

-- Keymaps
vim.keymap.set("n", "<leader>s,", M.toggle, { desc = "Toggle Scroll Mode" })
vim.keymap.set("n", "w", M.scroll_down, { desc = "Scroll Down 10", noremap = true })
vim.keymap.set("n", "e", M.scroll_up, { desc = "Scroll Up 10", noremap = true })

return M
err
