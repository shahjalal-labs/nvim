--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯

--p: ╭──────────── Block Start ────────────╮
local function copy_github_url()
	-- Get the origin URL from git config
	local handle = io.popen("git -C " .. vim.fn.getcwd() .. " config --get remote.origin.url")
	if not handle then
		print("Not a git repository or no origin remote")
		return
	end
	local url = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if url == "" then
		print("No remote origin URL found")
		return
	end

	-- Normalize URL: convert SSH to HTTPS or keep HTTPS
	local https_url
	if url:match("^git@") then
		-- Convert ssh: git@github.com:user/repo.git => https://github.com/user/repo
		https_url = url:gsub("^git@", "https://"):gsub(":", "/"):gsub("%.git$", "")
	else
		-- HTTPS url - remove trailing .git if any
		https_url = url:gsub("%.git$", "")
	end

	-- Copy to system clipboard (using vim.fn.setreg)
	vim.fn.setreg("+", https_url)
	print("Copied GitHub URL to clipboard: " .. https_url)
end

vim.keymap.set("n", "<leader>gy", copy_github_url, { desc = "Copy current repo GitHub URL" })
--p: ╰───────────── Block End ─────────────╯

--p: ╭──────────── Block Start ────────────╮
-- Open the current repository in the browser
vim.keymap.set("n", "<leader>gm", ":!gh repo view --web<CR>", { noremap = true, silent = true })
--p: ╰───────────── Block End ─────────────╯
--
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
--p: ╭──────────── Block Start ────────────╮

--p: ╰───────────── Block End ─────────────╯
