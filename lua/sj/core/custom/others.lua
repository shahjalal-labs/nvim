-- Function to copy the current line diagnostic to the system clipboard
function copy_line_diagnosticC()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if diagnostics[1] then
		local message = diagnostics[1].message
		vim.fn.setreg("+", message) -- Copy to system clipboard
		print("Diagnostic copied to clipboard: " .. message)
	else
		print("No diagnostic on the current line")
	end
end

-- Function to search the current line diagnostic message on Google
function google_search_diagnosticC()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if diagnostics[1] then
		local message = diagnostics[1].message
		-- URL-encode the message to make it safe for use in a URL
		local search_query =
			vim.fn.system("python3 -c 'import urllib.parse; print(urllib.parse.quote(\"" .. message .. "\"))'")
		local search_url = "https://www.google.com/search?q=" .. search_query:match("^%s*(.-)%s*$") -- trim whitespace
		vim.fn.jobstart({ "xdg-open", search_url }, { detach = true })
		print("Searching Google for: " .. message)
	else
		print("No diagnostic on the current line")
	end
end

-- Function to copy the current line diagnostic and open ChatGPT
function ask_chatgpt_about_diagnosticC()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if diagnostics[1] then
		local message = diagnostics[1].message
		-- Copy diagnostic message to clipboard
		vim.fn.setreg("+", message) -- Copies to system clipboard
		-- Open ChatGPT in the default browser
		vim.fn.jobstart({ "xdg-open", "https://chat.openai.com/" }, { detach = true })
		print("Diagnostic copied to clipboard. Opened ChatGPT; paste the message to ask.")
	else
		print("No diagnostic found on the current line")
	end
end

-- Key mappings for each diagnostic function
vim.api.nvim_set_keymap("n", "<space>dc", ":lua copy_line_diagnosticC()<CR>", { noremap = true, silent = true }) -- Copy diagnostic
vim.api.nvim_set_keymap("n", "<space>dg", ":lua google_search_diagnosticC()<CR>", { noremap = true, silent = true }) -- Google search diagnostic
vim.api.nvim_set_keymap("n", "<space>da", ":lua ask_chatgpt_about_diagnosticC()<CR>", { noremap = true, silent = true }) -- Ask ChatGPT
--
--
--
--
--
-- Function to get the current date and time in the desired format
local function get_current_datetime()
	local date = os.date("*t")
	local formatted_date = string.format(
		"%02d/%02d/%04d %02d:%02d %s %s GMT+6 Sharifpur, Gazipur, Dhaka",
		date.day,
		date.month,
		date.year,
		date.hour % 12 == 0 and 12 or date.hour % 12,
		date.min,
		date.hour >= 12 and "PM" or "AM",
		os.date("%a")
	) -- Get abbreviated weekday
	return formatted_date
end

-- Function to insert the date comment at the top of the file
local function insert_date_comment()
	local filetype = vim.bo.filetype
	local comment_prefix

	if filetype == "javascript" or filetype == "typescript" then
		comment_prefix = "//w:"
	elseif filetype == "python" then
		comment_prefix = "#"
	elseif filetype == "lua" then
		comment_prefix = "--"
	else
		return
	end

	-- Move cursor to the first line and insert the date comment
	local date_comment = string.format("%s %s", comment_prefix, get_current_datetime())
	vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- Move cursor to the first line
	vim.api.nvim_put({ date_comment }, "l", false, true) -- Insert the comment
end

-- Autocommand to insert the date comment when a new file is created
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*",
	callback = insert_date_comment,
})
--
--
--
--
--
--w: 06/11/2024 01:44 PM Wed GMT+6 Sharifpur, Gazipur, Dhaka
--
--
--
--
--multiple line searching is not working it's need to be okay
--w:  Function to URL-encode text
local function url_encode(str)
	if str then
		str = string.gsub(str, "([^%w _%%%-%.~])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "%%20") -- Encode spaces as %20
	end
	return str
end

-- Function to search Google with the current line or visual selection
function _G.search_google_selection()
	local query_text = ""

	if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
		-- Get start and end positions of the visual selection
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")
		local start_col = vim.fn.col("'<")
		local end_col = vim.fn.col("'>")

		-- Get all lines within the selection range
		local lines = vim.fn.getline(start_line, end_line)

		-- Handle column-specific trimming for first and last lines
		if #lines == 1 then
			-- Single line selection within start and end columns
			query_text = string.sub(lines[1], start_col, end_col)
		else
			-- Multi-line selection: trim first and last lines to selected columns
			lines[1] = string.sub(lines[1], start_col)
			lines[#lines] = string.sub(lines[#lines], 1, end_col)
			query_text = table.concat(lines, " ") -- Concatenate all lines with spaces
		end

		-- Exit visual mode after capturing selection
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	else
		-- If not in visual mode, use the current line
		query_text = vim.fn.getline(".")
	end

	-- URL-encode the query and construct search URL
	local encoded_query = url_encode(query_text)
	local search_url = "https://www.google.com/search?q=" .. encoded_query

	-- Open the URL in the default browser
	vim.fn.jobstart({ "xdg-open", search_url }, { detach = true })
end

-- Map `<leader>sg` to search Google with the current line or visual selection
vim.api.nvim_set_keymap("n", "<leader>sg", ":lua search_google_selection()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>sg", ":<C-u>lua search_google_selection()<CR>", { noremap = true, silent = true })

-- ╭──────────── Block Start ────────────╮

function create_jd_from_clipboard()
	local base_path = "/run/media/sj/developer/web/L1B11/career/JobDocuments"
	local handle = io.popen("ls -1 " .. base_path .. "/jd*.md 2>/dev/null")
	local files = handle:read("*a")
	handle:close()

	local max_n = 0
	for filename in string.gmatch(files, "jd(%d+)%.md") do
		local num = tonumber(filename)
		if num and num > max_n then
			max_n = num
		end
	end

	local next_n = max_n + 1
	local new_file = base_path .. "/jd" .. next_n .. ".md"

	-- get clipboard content (assumes wl-clipboard is installed)
	local handle_clip = io.popen("wl-paste")
	local content = handle_clip:read("*a")
	handle_clip:close()

	-- write to file
	local file = io.open(new_file, "w")
	if file then
		file:write(content)
		file:close()

		-- copy content back to clipboard for reuse
		local tmp = os.tmpname()
		local f = io.open(tmp, "w")
		f:write(content)
		f:close()
		os.execute("wl-copy < " .. tmp)
		os.remove(tmp)

		print("📄 Created JD: jd" .. next_n .. ".md and content re-copied to clipboard")
	else
		print("❌ Failed to create JD file.")
	end
end

vim.api.nvim_set_keymap("n", "<leader>pj", ":lua create_jd_from_clipboard()<CR>", { noremap = true, silent = true })
-- ╰───────────── Block End ─────────────╯
--
