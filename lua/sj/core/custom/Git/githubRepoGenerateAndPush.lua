-- Combined Neovim Lua script: Auto GitHub Init + Surge `CNAME` + developer.md

local function to_slug(name)
	return name:lower():gsub("[^%w]", ""):gsub("client", ""):gsub("server", "")
end

local function detect_slug()
	local cwd = vim.fn.getcwd()
	local dir = vim.fn.fnamemodify(cwd, ":t")
	return to_slug(dir)
end

local function write_file_if_not_exists(path, content)
	local f = io.open(path, "r")
	if f then
		f:close()
		return
	end
	f = io.open(path, "w")
	if f then
		f:write(content)
		f:close()
	end
end

local function write_surge_cname_and_dev_info()
	local slug = detect_slug()
	local surge_url = slug .. ".surge.sh"

	-- Create public/CNAME
	vim.fn.mkdir("public", "p")
	write_file_if_not_exists("public/CNAME", surge_url)

	-- Create developer.md
	local dev_info = [[
# 👨‍💻 Developer Info

- Name: Md. Shahjalal
- GitHub: https://github.com/shahjalal-labs
- Email: muhommodshahjalal@gmail.com
- Phone: 01540325659
- Portfolio: http://shahjalal-labs.surge.sh
- LinkedIn: https://www.linkedin.com/in/shahjalal-labs/
- Facebook: https://www.facebook.com/shahjalal.labs
- Twitter: https://x.com/shahjalal_labs

> Powered by Lua script automation in Neovim
  ]]

	write_file_if_not_exists("developer.md", dev_info)

	-- Git add + commit
	vim.fn.system("git add public/CNAME developer.md")
	vim.fn.system("git commit -m 'Add CNAME and developer profile'")
end

local function createGitRepoAndPushToGithub()
	-- Full GitHub init and README write logic (from your given code)
	-- ⬇️ Place your large GitHub init logic here (unchanged)

	-- Call the helper to add CNAME and dev info after successful push
	write_surge_cname_and_dev_info()
end

-- 🔥 Map to <leader>Z to start this workflow
vim.keymap.set("n", "<leader>gk", createGitRepoAndPushToGithub, { desc = "🚀 Auto GitHub + Surge + Dev Profile" })
