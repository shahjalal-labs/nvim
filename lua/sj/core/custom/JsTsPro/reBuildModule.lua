local api = vim.api
local uv = vim.loop

-- Recursively list all files under a directory
local function list_files(dir, file_list)
	file_list = file_list or {}
	local handle = uv.fs_scandir(dir)
	if not handle then
		return file_list
	end

	while true do
		local name, typ = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		local full_path = dir .. "/" .. name

		if typ == "file" then
			table.insert(file_list, full_path)
		elseif typ == "directory" then
			list_files(full_path, file_list)
		end
	end
	return file_list
end

-- Read full file content, safely
local function read_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local content = fd:read("*a")
	fd:close()
	return content
end

-- Write content to a file, safely
local function write_file(path, content)
	local fd = io.open(path, "w")
	if not fd then
		api.nvim_err_writeln("Failed to write file: " .. path)
		return false
	end
	fd:write(content)
	fd:close()
	return true
end

-- Extract last folder name as module name
local function extract_module_name(path)
	local segments = {}
	for seg in path:gmatch("[^/]+") do
		table.insert(segments, seg)
	end
	return segments[#segments] or "module"
end

-- Generate markdown snippet for each file with syntax highlighting hint
local function generate_file_markdown(filepath, root_path)
	local relative_path = filepath:gsub(root_path .. "/", "")
	local content = read_file(filepath) or "// ERROR: Could not read file"
	local ext = filepath:match("^.+%.(%w+)$") or "txt"
	return string.format("### File: ./%s\n\n```%s\n%s\n```\n\n", relative_path, ext, content)
end

-- Main function: generate prompt markdown from clipboard folder path
local function generate_prompt_from_clipboard()
	local clipboard_path = vim.fn.getreg("+")
	if clipboard_path == "" or not uv.fs_stat(clipboard_path) then
		api.nvim_err_writeln("Clipboard does not contain a valid path: " .. clipboard_path)
		return
	end

	local module_name = extract_module_name(clipboard_path)
	local files = list_files(clipboard_path)

	if #files == 0 then
		api.nvim_err_writeln("No files found in path: " .. clipboard_path)
		return
	end

	local prompt_header = [[
You are a senior full-stack developer.

Your task is to **refactor and modernize** the following codebase module to align with **real-world best practices**, **modular structure**, and **enterprise-grade scalability**.

---

### ✅ Goals:

- Improve modularity and code separation
- Enhance code clarity, consistency, and readability
- Follow real-world React + Node.js architectural patterns
- Preserve **all existing functionality**
- Make the structure scalable, testable, and production-ready
- Optimize naming, reuse patterns, and programmatic structure

---

### 🔧 Files to refactor:
]]

	local files_markdown = {}
	for _, filepath in ipairs(files) do
		table.insert(files_markdown, generate_file_markdown(filepath, clipboard_path))
	end

	local prompt_footer = [[
---

Please refactor these files with best practices and generate a `.sh` rebuild script that will:

- Create a new folder named `updated]] .. module_name .. [[`
- Write all improved files there without overwriting the current folder
- Automate git commit of the new folder
- Ensure no existing files are overwritten

]]

	local full_prompt = prompt_header .. table.concat(files_markdown) .. prompt_footer

	local prompt_filename = "refactorPrompt_" .. module_name .. ".md"
	local success = write_file(prompt_filename, full_prompt)
	if success then
		api.nvim_out_write("✅ Refactor prompt generated: " .. prompt_filename .. "\n")
	end
end

-- Bind <leader>ge to run the generate prompt function
api.nvim_set_keymap("n", "<leader>ge", "", {
	noremap = true,
	silent = true,
	callback = generate_prompt_from_clipboard,
})
