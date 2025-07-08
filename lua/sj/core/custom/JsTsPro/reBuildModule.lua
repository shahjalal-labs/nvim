vim.keymap.set("n", "<leader>ge", function()
	local module_path = vim.fn.system("wl-paste"):gsub("%s+$", "")
	if vim.fn.isdirectory(module_path) == 0 then
		vim.notify("❌ Not a valid folder: " .. module_path, vim.log.levels.ERROR)
		return
	end

	local module_name = module_path:match("([^/]+)$") or "Unknown"
	local prompt_file = module_path .. "/refractor" .. module_name:gsub("^%l", string.upper) .. "Prompt.md"

	local tree_cmd = "tree -I '.git|node_modules' '" .. module_path .. "'"
	local tree_output = vim.fn.systemlist(tree_cmd)

	local header = {
		"You are a **senior full-stack developer**.",
		"",
		"## 📌 Task",
		"",
		"You are given a real-world code module located at:",
		"",
		"```",
		module_path,
		"```",
		"",
		"Refactor the entire codebase **without modifying any UI or changing behavior**. Instead, improve it using:",
		"",
		"- ✅ Clear separation of concerns",
		"- ✅ Consistent, semantic naming conventions",
		"- ✅ Modular architecture (hooks, services, utils, components)",
		"- ✅ Scalable file/folder structure",
		"- ✅ Industry-standard project layout and architecture",
		"- ✅ Readable, testable, production-grade code",
		"- ✅ 100% behavior and API compatibility",
		"",
		"👉 Output the refactored code to a new folder: `" .. module_name .. "_refactored`",
		"",
		"Also return a `.sh` script that will:",
		"- Create that folder",
		"- Write all refactored files",
		"- Run `git add` and `git commit` with message: `refactor: added improved " .. module_name .. " version`",
		"",
		"---",
		"",
		"## 🌲 Full Project Structure (for context)",
		"",
		"```bash",
	}

	vim.list_extend(header, tree_output)
	table.insert(header, "```")
	table.insert(header, "")
	table.insert(header, "## 📁 Module Files & Contents")
	table.insert(header, "")

	local handle = io.popen('find "' .. module_path .. '" -type f')
	local filelist = handle:read("*a")
	handle:close()

	local prompt = vim.deepcopy(header)

	for file in vim.split(filelist, "\n", { trimempty = true }) do
		local ext = file:match("^.+(%..+)$") or ""
		local lang = ext:gsub("%.", ""):gsub("jsx", "javascript"):gsub("tsx", "typescript"):gsub("js", "javascript")
		local rel_path = file:sub(#module_path + 2)
		local lines = vim.fn.readfile(file)
		if #lines > 0 then
			table.insert(prompt, "### `" .. rel_path .. "`")
			table.insert(prompt, "```" .. lang)
			vim.list_extend(prompt, lines)
			table.insert(prompt, "```")
			table.insert(prompt, "")
		end
	end

	local prompt_str = table.concat(prompt, "\n")
	local file = io.open(prompt_file, "w")
	file:write(prompt_str)
	file:close()

	-- Copy to clipboard using wl-copy
	vim.fn.system("wl-copy", prompt_str)

	vim.notify("✅ Prompt saved to:\n" .. prompt_file .. "\n📋 Prompt copied to clipboard", vim.log.levels.INFO)
end, { desc = "Generate full LLM refactor prompt from clipboard path" })
