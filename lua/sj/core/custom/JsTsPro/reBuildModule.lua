function RebuildModuleFromClipboard()
	local Path = require("plenary.path")
	local scan = require("plenary.scandir")

	-- Read path from clipboard
	local handle = io.popen("xclip -selection clipboard -o")
	local modulePath = handle:read("*a"):gsub("%s+$", "")
	handle:close()

	if modulePath == "" then
		print("❌ Clipboard is empty or invalid path.")
		return
	end

	-- Get module name from path
	local moduleName = vim.fn.fnamemodify(modulePath, ":t")
	local outputPath = "generate" .. moduleName .. ".md"

	-- Read prompt template
	local promptTemplate = Path:new("promptTemplate.txt"):read()

	-- Scan all files (js, jsx, ts, tsx, json, css, html, etc.)
	local files = scan.scan_dir(modulePath, {
		hidden = false,
		add_dirs = false,
		depth = 10,
		search_pattern = ".*",
	})

	-- Start writing output
	local out = io.open(outputPath, "w")
	out:write(promptTemplate .. "\n\n")

	for _, file in ipairs(files) do
		local relPath = file:gsub(vim.pesc(modulePath .. "/"), "")
		out:write("### File: ./" .. relPath .. "\n")
		out:write(Path:new(file):read() .. "\n\n")
	end

	out:close()
	print("✅ Prompt file generated: " .. outputPath)
end
