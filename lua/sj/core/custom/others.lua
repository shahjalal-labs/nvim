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
--
-- vim.keymap.set("n", "<leader>pj", function()
-- 	local jobdir = "/run/media/sj/developer/web/L1B11/career/JobDocuments/jobDescription/"
-- 	local base = jobdir .. "jd"
-- 	local ext = ".md"
--
-- 	-- Step 1: Read clipboard
-- 	local clipboard = vim.fn.system("wl-paste")
-- 	clipboard = clipboard:gsub("\r", "") -- clean carriage return
--
-- 	-- Step 2: Find next available filename
-- 	local filename = base .. ext
-- 	local i = 1
-- 	while vim.fn.filereadable(filename) == 1 do
-- 		filename = base .. i .. ext
-- 		i = i + 1
-- 	end
--
-- 	-- Step 3: Prompt template
-- 	local prompt = [[
-- ### 📋 INSTRUCTIONS:
-- You are a job formatter. Convert the following **raw job description** into a structured and detailed markdown format like the sample below.
--
-- #### 🔧 Your Task:
-- 1. Extract key information: company name, title, location, timezone, type, stack (required & optional), how to apply.
-- 2. Convert currencies to BDT and show original.
-- 3. Convert timezones to GMT+6 (Dhaka), retain original too.
-- 4. Generate output using this exact markdown structure:
--
-- ```markdown
-- ### 1. `🏢 Company Name — Job Title`
--
-- <pre><code>
-- 📅 Applied On: (Not yet applied)
-- 💰 Stipend/Salary : ORIGINAL ≈ BDT / Monthly
-- ⏰ Hours: Dhaka Time (GMT+6) → Original Timezone
-- 🧰 Stack: Required stacks
-- 📆 Interview Date: (Not yet scheduled)
-- 🌐 Location: Full Location + timezone
-- 🧭 Platform: Application Source (e.g., Discord/Email)
-- ⏳ Status: 🟡 Pending
-- </code></pre>
--
-- 🔗 [Company Website]() `url` <br />
-- 🔗 [Job Link]() `link`
--
-- <details>
-- <summary>📓 Notes</summary>
--
-- - Mention any assumptions or missing info.
-- - Application method (DM, Email, Google Form, etc).
-- </details>
--
--   ]] .. clipboard .. "\n```"
--
-- 	-- Step 4: Write to file
-- 	local f = io.open(filename, "w")
-- 	if f then
-- 		f:write(prompt)
-- 		f:close()
-- 	else
-- 		vim.notify("❌ Failed to write job file", vim.log.levels.ERROR)
-- 		return
-- 	end
--
-- 	-- Step 5: Open in current tab
-- 	vim.cmd("edit " .. filename)
--
-- 	-- Step 6: Copy prompt to clipboard
-- 	vim.fn.system("wl-copy", prompt)
--
-- 	vim.notify("✅ JD prompt created: " .. vim.fn.fnamemodify(filename, ":t"))
-- end, { desc = "Create job prompt from clipboard (JD)" })
--
-- ╰───────────── Block End ─────────────╯
--

vim.keymap.set("n", "<leader>pj", function()
	local jobdir = "/run/media/sj/developer/web/L1B11/career/JobDocuments/jobDescription/"
	local base = jobdir .. "jd"
	local ext = ".md"

	-- Get clipboard content
	local clipboard = vim.fn.system("wl-paste")
	clipboard = clipboard:gsub("\r", "")

	-- Find next available filename
	local filename = base .. ext
	local i = 1
	while vim.fn.filereadable(filename) == 1 do
		filename = base .. i .. ext
		i = i + 1
	end

	-- Get current date
	local date = os.date("%Y-%m-%d")

	-- Build the full LLM prompt as markdown
	local prompt = [[
### 📋 LLM TASK INSTRUCTIONS  
📅 Date: ]] .. date .. [[

You are an expert job formatter.

---

#### 🔧 Your Task:
1. Read and **explain the job** in human-friendly detail: role, company, location, compensation, type.  
2. **Convert all currencies to BDT**, keeping the original.  
3. **Convert timezones to GMT+6** (Dhaka), keeping the original.  
4. **Categorize stack** into:  
   - ✅ Required stack  
   - 🔧 Mentioned/optional stack  
5. **Explain how to apply**, if mentioned (email, form, DM, etc.)  
6. **Then generate a README-style markdown summary** using this exact structure:

```markdown
### 1. `🏢 Company Name — Job Title`

<pre><code>
📅 Applied On: ]] .. date .. [[
💰 Stipend/Salary : Original ≈ Converted BDT / Monthly
⏰ Hours: Bangladesh Time → Original Timezone
🧰 Stack: Required Tech Stack
📆 Interview Date: (If known or write "Not yet scheduled")
🌐 Location: Full Location + Timezone
🧭 Platform: Source or Application method
⏳ Status: 🟡 Pending or other
</code></pre>

🔗 [Company Website](url) `url` <br />
🔗 [Job Link](link) `link`

<details>
<summary>📓 Notes</summary>

- Assumptions, stack uncertainties, tips.
- Any advice on how to tailor application.
</details>
]] .. clipboard .. "\n```"

	-- Write prompt to the file
	local f = io.open(filename, "w")
	if f then
		f:write(prompt)
		f:close()
	else
		vim.notify("❌ Failed to write job file", vim.log.levels.ERROR)
		return
	end

	-- Open in current buffer
	vim.cmd("edit " .. filename)

	-- Copy prompt to system clipboard
	vim.fn.system("wl-copy", prompt)

	vim.notify("✅ JD prompt created: " .. vim.fn.fnamemodify(filename, ":t"))
end, { desc = "Create job prompt from clipboard (JD)" })
