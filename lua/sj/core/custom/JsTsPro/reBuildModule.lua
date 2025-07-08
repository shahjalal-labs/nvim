local uv = vim.loop
local fn = vim.fn
local api = vim.api

-- Try Wayland clipboard first, fallback to X11
local function get_clipboard_path()
	local path = fn.system("wl-paste 2>/dev/null"):gsub("%s+$", "")
	if path == "" then
		path = fn.system("xclip -o -selection clipboard 2>/dev/null"):gsub("%s+$", "")
	end
	return path ~= "" and path or nil
end

local function get_module_name(path)
	return path:match("([^/\\]+)$")
end

local function get_all_files(dir)
	local files = {}
	local handle = io.popen('find "' .. dir .. '" -type f')
	if handle then
		for file in handle:lines() do
			table.insert(files, file)
		end
		handle:close()
	end
	return files
end

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

local function write_file(path, content)
	local f = io.open(path, "w")
	if f then
		f:write(content)
		f:close()
	end
end

local function ucfirst(str)
	return (str:gsub("^%l", string.upper))
end

function RebuildModuleFromClipboard()
	local original_path = get_clipboard_path()
	if not original_path then
		api.nvim_err_writeln("❌ Failed to read path from clipboard.")
		return
	end

	local module = get_module_name(original_path)
	if not module then
		api.nvim_err_writeln("❌ Invalid module path.")
		return
	end

	local parent_dir = original_path:match("(.+)/[^/]+$")
	local updated_dir = parent_dir .. "/updated" .. ucfirst(module)
	fn.mkdir(updated_dir, "p")
	fn.system('cp -r "' .. original_path .. '/"* "' .. updated_dir .. '/"')

	-- Embedded prompt template
	local prompt_template = [[
You are a senior full-stack developer.

Rewrite the following files to follow real-world best practices, modular architecture, scalability, and clarity. 
Your goals are:

✅ Improve modularity  
✅ Enhance readability  
✅ Follow real-world React + Node best practices  
✅ Modernize structure if needed  
✅ DO NOT REMOVE functionality

Also, generate a `.sh` script that:
- Backs up the old module
- Replaces it with the updated one
- Runs `diff -rq` before overwrite
- Commits with: `refactor: improved <module>`
]]

	local all_files = get_all_files(updated_dir)
	local out_md = { prompt_template, "" }

	for _, filepath in ipairs(all_files) do
		local rel = filepath:sub(#updated_dir + 2)
		local content = read_file(filepath)
		if content then
			table.insert(out_md, "### File: ./" .. rel)
			table.insert(out_md, "```" .. (rel:match("%.(%a+)$") or "txt"))
			table.insert(out_md, content)
			table.insert(out_md, "```")
			table.insert(out_md, "")
		end
	end

	local md_path = updated_dir .. "/generate" .. ucfirst(module) .. ".md"
	write_file(md_path, table.concat(out_md, "\n"))

	-- Optional diff save file
	fn.mkdir(updated_dir .. "/diffs", "p")
	write_file(updated_dir .. "/diffs/original-vs-new.txt", "-- paste your diffs here")

	api.nvim_out_write("✅ Rebuild prompt generated at → " .. md_path .. "\n")
end

vim.keymap.set("n", "<leader>ge", RebuildModuleFromClipboard, { desc = "📦 Rebuild module from clipboard path" })
