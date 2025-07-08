local api = vim.api
local uv = vim.loop

local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function copy_to_clipboard(text)
	-- Try wl-copy (Wayland)
	if os.execute("command -v wl-copy > /dev/null 2>&1") == 0 then
		local proc = io.popen("wl-copy", "w")
		proc:write(text)
		proc:close()
		return
	end
	-- Try xclip (X11)
	if os.execute("command -v xclip > /dev/null 2>&1") == 0 then
		local proc = io.popen("xclip -selection clipboard", "w")
		proc:write(text)
		proc:close()
		return
	end
	api.nvim_err_writeln("Error: No clipboard tool found (wl-copy or xclip).")
end

function RebuildModuleFromClipboard()
	local clipboard_raw = vim.fn.getreg("+")
	local clipboard_path = trim(clipboard_raw)

	api.nvim_out_write("Debug: Clipboard path read: [" .. clipboard_path .. "]\n")

	if clipboard_path == "" then
		api.nvim_err_writeln("Clipboard is empty.")
		return
	end

	local stat = uv.fs_stat(clipboard_path)
	if not stat or stat.type ~= "directory" then
		api.nvim_err_writeln("Clipboard does not contain a valid directory path: " .. clipboard_path)
		return
	end

	local prompt = [[
You are a senior full-stack developer.

Your task is to refactor and modernize the module at path: ]] .. clipboard_path .. [[

- Follow best practices
- Modular structure
- Preserve functionality
- Make it scalable and programmatical

Please generate:
1. Fully rewritten source files with improved structure
2. A .sh rebuild script that will create a new folder "updatedModule" alongside the original path without overwriting anything.

]]

	copy_to_clipboard(prompt)
	api.nvim_out_write("Prompt copied to clipboard. Paste it into your LLM.\n")
end

-- Bind the function to <leader>ge in normal mode
api.nvim_set_keymap("n", "<leader>ge", "<cmd>lua RebuildModuleFromClipboard()<CR>", { noremap = true, silent = true })
