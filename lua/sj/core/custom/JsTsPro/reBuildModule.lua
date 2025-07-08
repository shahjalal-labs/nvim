local uv = vim.loop

-- Utility: Check if file exists
local function file_exists(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type == "file"
end

-- Utility: Recursively list all files in directory
local function list_files_recursive(dir)
	local files = {}

	local function scan(dir)
		local req = uv.fs_scandir(dir)
		if not req then
			return
		end

		while true do
			local name, typ = uv.fs_scandir_next(req)
			if not name then
				break
			end
			local fullpath = dir .. "/" .. name

			if typ == "directory" then
				scan(fullpath)
			elseif typ == "file" then
				table.insert(files, fullpath)
			end
		end
	end

	scan(dir)
	return files
end

-- Read whole file content
local function read_file(path)
	local fd = uv.fs_open(path, "r", 438)
	if not fd then
		return nil
	end
	local stat = uv.fs_fstat(fd)
	if not stat then
		uv.fs_close(fd)
		return nil
	end
	local data = uv.fs_read(fd, stat.size, 0)
	uv.fs_close(fd)
	return data
end

-- Get clipboard text (try wl-copy, xclip fallback)
local function copy_to_clipboard(text)
	local function try_cmd(cmd)
		local handle = io.popen(cmd)
		local result = handle:read("*a")
		handle:close()
		return result
	end

	-- We'll write to clipboard via system commands
	local function run_cmd_write(cmd)
		local p = io.popen(cmd, "w")
		if p then
			p:write(text)
			p:close()
			return true
		end
		return false
	end

	-- Try wl-copy (Wayland)
	if os.execute("command -v wl-copy > /dev/null 2>&1") == 0 then
		if run_cmd_write("wl-copy") then
			return true
		end
	end

	-- Try xclip (X11)
	if os.execute("command -v xclip > /dev/null 2>&1") == 0 then
		if run_cmd_write("xclip -selection clipboard") then
			return true
		end
	end

	print("Failed to copy to clipboard: no wl-copy or xclip found.")
	return false
end

-- Read clipboard content (try wl-paste, xclip fallback)
local function get_clipboard_text()
	local function run_cmd_read(cmd)
		local p = io.popen(cmd, "r")
		if not p then
			return nil
		end
		local result = p:read("*a")
		p:close()
		return result and result:gsub("%s+$", "") -- trim trailing spaces/newlines
	end

	if os.execute("command -v wl-paste > /dev/null 2>&1") == 0 then
		local data = run_cmd_read("wl-paste")
		if data and #data > 0 then
			return data
		end
	end

	if os.execute("command -v xclip > /dev/null 2>&1") == 0 then
		local data = run_cmd_read("xclip -selection clipboard -o")
		if data and #data > 0 then
			return data
		end
	end

	return nil
end

-- Main function: generate prompt markdown
local function generate_prompt_from_path(base_path)
	local files = list_files_recursive(base_path)
	if #files == 0 then
		error("No files found in path: " .. base_path)
	end

	-- Extract module name from path (last folder name)
	local module_name = base_path:match("^.+/(.+)$") or "Module"

	-- Base prompt instructions
	local prompt_header = [[
## ✍️ Refactor & Modernize Module

You are a senior full-stack developer.

Your task is to **refactor and modernize** the following module code to follow:

- Real-world best practices  
- Modular architecture  
- Enterprise-grade scalability  
- Preserve all existing functionality  
- Programmatical and scalable structure

---

### Files in module:  

]]

	-- Append each file content wrapped in markdown
	local prompt_files = {}

	for _, filepath in ipairs(files) do
		local relative_path = filepath:sub(#base_path + 2) -- +2 to remove trailing slash and slash
		local content = read_file(filepath) or ""

		-- Escape backticks in content to avoid markdown issues (optional)
		content = content:gsub("```", "``‌`")

		table.insert(prompt_files, string.format("### File: %s\n```js\n%s\n```", relative_path, content))
	end

	-- Join files content
	local prompt_body = table.concat(prompt_files, "\n\n")

	-- Full prompt text
	local prompt_text = prompt_header
		.. prompt_body
		.. "\n\n---\n\nPlease rewrite these files with the best practices, modularity, clarity, and scalability.\n"

	return prompt_text, module_name
end

-- Write string to file
local function write_file(path, content)
	local fd = uv.fs_open(path, "w", 438)
	if not fd then
		error("Failed to open file for writing: " .. path)
	end
	uv.fs_write(fd, content, 0)
	uv.fs_close(fd)
end

-- Main entrypoint
local function RebuildModuleFromClipboard()
	local clip_text = get_clipboard_text()
	if not clip_text or clip_text == "" then
		print("Error: Clipboard does not contain a valid path.")
		return
	end

	-- Normalize path (remove trailing slash)
	local path = clip_text:gsub("/+$", "")

	-- Check if path exists
	local stat = uv.fs_stat(path)
	if not stat or stat.type ~= "directory" then
		print("Error: Clipboard does not contain a valid directory path: " .. path)
		return
	end

	local prompt_text, module_name = generate_prompt_from_path(path)

	-- Save prompt file inside base path
	local prompt_file_path = path .. "/dynamicModuleGeneratePrompt.md"
	write_file(prompt_file_path, prompt_text)
	print("Prompt saved to: " .. prompt_file_path)

	-- Copy prompt text to clipboard
	if copy_to_clipboard(prompt_text) then
		print("Prompt copied to clipboard successfully.")
	else
		print("Prompt saved but failed to copy to clipboard.")
	end
end

-- Bind to <leader>ge in Neovim
vim.api.nvim_set_keymap("n", "<leader>ge", ":lua RebuildModuleFromClipboard()<CR>", { noremap = true, silent = true })

-- For manual call
return {
	RebuildModuleFromClipboard = RebuildModuleFromClipboard,
}
