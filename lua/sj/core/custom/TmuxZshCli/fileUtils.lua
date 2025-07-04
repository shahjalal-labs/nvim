-- ╭──────────── Block Start ────────────╮

-- ╰───────────── Block End ─────────────╯

--w: 1╭──────────── Block Start ────────────╮
--p: Open current file in browser (firefox/chrome)
local function open_with_firefox_or_chrome(filepath)
	local browser
	if vim.fn.executable("firefox") == 1 then
		browser = "firefox"
	elseif vim.fn.executable("google-chrome") == 1 then
		browser = "google-chrome"
	else
		print("❌ Neither firefox nor google-chrome found.")
		return
	end
	vim.fn.jobstart({ browser, filepath }, { detach = true })
	print("🌐 Opened with " .. browser .. ": " .. filepath)
end

vim.keymap.set({ "n", "i" }, "<space>sa", function()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		print("❌ No file to open.")
		return
	end
	open_with_firefox_or_chrome(filepath)
end, { desc = "Open current file in browser (firefox/chrome)" })

--w: 1╰───────────── Block End ─────────────╯
--
--
--
--w: 2╭──────────── Block Start ────────────╮
--t:copy the absolute path of the current file in Neovim using space sj
vim.api.nvim_set_keymap("n", "<space>sj", ":lua CopyAbsolutePath()<CR>", { noremap = true, silent = true })

function CopyAbsolutePath()
	local file_path = vim.fn.expand("%:p") -- Get the absolute path of the current file
	vim.fn.setreg("+", file_path) -- Copy the path to the system clipboard
	print("Copied path: " .. file_path)
end
--w: 2╰───────────── Block End ─────────────╯
--
--
--
--w: 3╭──────────── Block Start ────────────╮
-- Generate clean directory tree markdown
local function generate_structure_md()
	local cwd = vim.fn.getcwd()
	local output_file = cwd .. "/structure.md"

	local handle = io.popen("tree -C -I '.git|node_modules|.DS_Store|dist'")
	if not handle then
		print("❌ Failed to run tree command.")
		return
	end

	local result = handle:read("*a")
	handle:close()

	-- Remove ANSI color codes
	result = result:gsub("\27%[[0-9;]*m", "")

	local file = io.open(output_file, "w")
	if not file then
		print("❌ Cannot open structure.md for writing.")
		return
	end

	file:write("# 📁 Project Structure\n\n")
	file:write("```bash\n")
	file:write(result)
	file:write("\n```\n")
	file:close()

	print("✅ structure.md updated successfully.")
end

vim.keymap.set("n", "<leader>ds", generate_structure_md, {
	noremap = true,
	silent = true,
	desc = "🗂️ Generate structure.md",
})
--w: 3╰───────────── Block End ─────────────╯
--go to package.json file
vim.keymap.set("n", "<leader>pp", function()
	local package_json_path = vim.fn.findfile("package.json", ".;")
	if package_json_path ~= "" then
		vim.cmd("edit " .. package_json_path)
	else
		print("No package.json file found in the current project.")
	end
end, { noremap = true, silent = true, desc = "Open package.json" })

-- Search for index.css under the src directory, starting from the current directory
vim.keymap.set("n", "<leader>fi", function()
	local index_css_path = vim.fn.findfile("src/index.css", ".;")
	if index_css_path ~= "" then
		vim.cmd("edit " .. index_css_path)
	else
		print("No src/index.css file found in the current project.")
	end
end, { noremap = true, silent = true, desc = "Open src/index.css" })

-- Define the function
local function goToRouterJsx()
	local paths = {
		"src/router.jsx",
		"src/router/router.jsx",
		"router.jsx",
	}

	-- Try direct common paths first
	for _, path in ipairs(paths) do
		if vim.fn.filereadable(path) == 1 then
			vim.cmd("edit " .. path)
			print("Opened: " .. path)
			return
		end
	end

	-- Fallback to search via `find`
	local result = vim.fn.systemlist("find . -type f -name 'router.jsx'")
	if #result > 0 then
		vim.cmd("edit " .. result[1])
		print("Found and opened: " .. result[1])
	else
		print("router.jsx not found.")
	end
end

-- Bind it to <leader>ae
vim.keymap.set("n", "<leader>ae", goToRouterJsx, { desc = "Open router.jsx" })

local function goToMainJsx()
	local path = "main.jsx"
	if vim.fn.filereadable(path) == 1 then
		vim.cmd("edit " .. path)
		print("Opened: " .. path)
		return
	end

	-- fallback if maybe not in exact root
	local result = vim.fn.systemlist("find . -maxdepth 2 -type f -name 'main.jsx'")
	if #result > 0 then
		vim.cmd("edit " .. result[1])
		print("Found and opened: " .. result[1])
	else
		print("main.jsx not found.")
	end
end

-- Bind to <leader>am
vim.keymap.set("n", "<leader>am", goToMainJsx, { desc = "Open main.jsx" })

-- Lua function to open the README.md file from the project root
local function openProjectReadme()
	local util = require("lspconfig.util") -- Neovim LSP util for root detection

	-- Detect root dir using common project markers
	local root_dir = util.root_pattern("package.json", "README.md")(vim.fn.expand("%:p"))

	if root_dir then
		local readme_path = root_dir .. "/README.md"
		if vim.fn.filereadable(readme_path) == 1 then
			vim.cmd("edit " .. readme_path)
		else
			vim.notify("README.md not found in project root.", vim.log.levels.WARN)
		end
	else
		vim.notify("Project root not found.", vim.log.levels.ERROR)
	end
end

-- Optional: map it to a keybinding (like <leader>rd)
vim.keymap.set("n", "<leader>rd", openProjectReadme, { desc = "Open project root README.md" })
