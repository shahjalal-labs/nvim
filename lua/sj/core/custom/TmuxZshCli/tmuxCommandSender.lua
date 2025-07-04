-- w: ╭──────────── Block Start ────────────╮
--t: Function to send build command to tmux pane
function SendBuildCommandToTmuxPane()
	vim.ui.input({ prompt = "Enter tmux pane number (default 2): " }, function(input)
		-- If input is empty or nil, default to "2"
		local pane = (input == nil or input == "") and "2" or input

		local cmd = "bun run build && cp dist/index.html dist/200.html && surge ./dist"
		local tmux_cmd = string.format("tmux send-keys -t %s '%s' Enter", pane, cmd)

		vim.fn.system(tmux_cmd)
		print("Command sent to tmux pane " .. pane)
	end)
end

vim.api.nvim_set_keymap("n", "<leader>tb", ":lua SendBuildCommandToTmuxPane()<CR>", { noremap = true, silent = true })

-- w: ╰───────────── Block End ─────────────╯
