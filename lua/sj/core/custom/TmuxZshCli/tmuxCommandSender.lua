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
-- w: ╭──────────── Block Start ────────────╮
-- Sends current line or visual selection to a Tmux pane.
-- Features:
--   - Normal mode: sends the current line
--   - Visual mode: sends the selected block
--   - Prompts for Tmux pane number (defaults to pane 2 if blank)
--   - Sends command to the specified Tmux pane using `tmux send-keys`

function SendCliCommandToTmuxPane()
	local mode = vim.fn.mode()
	local command = ""

	-- Get command based on mode
	if mode == "v" or mode == "V" then
		vim.cmd('normal! gv"xy') -- Copy visual selection to register "x"
		command = vim.fn.getreg("x")
	else
		command = vim.api.nvim_get_current_line()
	end

	command = command:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace

	if command == "" then
		vim.notify("No command to execute!", vim.log.levels.WARN)
		return
	end

	local pane_number = vim.fn.input("Enter Tmux Pane Number (default: 2): ")
	if pane_number == "" then
		pane_number = "2"
	end

	local tmux_command = string.format('tmux send-keys -t %s "%s" Enter', pane_number, command)
	vim.fn.system(tmux_command)

	vim.notify("Sent to Tmux Pane " .. pane_number .. ": " .. command, vim.log.levels.INFO)
end

-- Keybindings: Alt + d in Normal, Insert, and Visual modes
vim.api.nvim_set_keymap("n", "<A-d>", ":lua SendCliCommandToTmuxPane()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-d>", "<Esc>:lua SendCliCommandToTmuxPane()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-d>", ":lua SendCliCommandToTmuxPane()<CR>", { noremap = true, silent = true })
-- w: ╰───────────── Block End ─────────────╯
