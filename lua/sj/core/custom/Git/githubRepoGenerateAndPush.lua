-- --w: updated
-- --p: ╭──────────── Block Start ────────────╮
-- local function slugify(str)
-- 	return str:lower():gsub("[^%w]", "")
-- end
--
-- local function strip_marker(name)
-- 	local lower = name:lower()
-- 	for _, marker in ipairs({ "client", "server" }) do
-- 		if lower:sub(-#marker) == marker then
-- 			local sep_pos = #name - #marker
-- 			if name:sub(sep_pos, sep_pos) == "-" or name:sub(sep_pos, sep_pos) == "_" then
-- 				return name:sub(1, sep_pos - 1)
-- 			else
-- 				return name:sub(1, #name - #marker)
-- 			end
-- 		end
-- 		if lower:sub(1, #marker) == marker then
-- 			local sep_pos = #marker + 1
-- 			if name:sub(sep_pos, sep_pos) == "-" or name:sub(sep_pos, sep_pos) == "_" then
-- 				return name:sub(sep_pos + 1)
-- 			else
-- 				return name:sub(#marker + 1)
-- 			end
-- 		end
-- 	end
-- 	return name
-- end
--
-- local function is_react_project()
-- 	local package_json_path = vim.fn.getcwd() .. "/package.json"
-- 	if vim.fn.filereadable(package_json_path) == 1 then
-- 		local content = table.concat(vim.fn.readfile(package_json_path), "\n")
-- 		return content:match('"react"%s*:') ~= nil
-- 	end
-- 	return false
-- end
--
-- local function update_index_html_title(slug)
-- 	local html_path = vim.fn.getcwd() .. "/index.html"
-- 	if vim.fn.filereadable(html_path) == 1 then
-- 		local content = vim.fn.readfile(html_path)
-- 		for i, line in ipairs(content) do
-- 			if line:match("<title>") then
-- 				content[i] = "    <title>" .. slug .. "</title>"
-- 				break
-- 			end
-- 		end
-- 		vim.fn.writefile(content, html_path)
-- 	end
-- end
--
-- local function tmux_pane_exists(pane_num)
-- 	local panes = vim.fn.systemlist("tmux list-panes -F '#P'")
-- 	for _, pane in ipairs(panes) do
-- 		if tonumber(pane) == pane_num then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
--
-- local function send_to_tmux(pane, cmd)
-- 	local full_cmd = string.format("tmux send-keys -t %d '%s' Enter", pane, cmd)
-- 	os.execute(full_cmd)
-- end
--
-- local function createGitRepoAndPushToGithub()
-- 	local cwd = vim.fn.getcwd()
-- 	local folder_name = vim.fn.fnamemodify(cwd, ":t")
-- 	local base_name = strip_marker(folder_name)
-- 	local project_slug = slugify(base_name)
-- 	local live_site = "https://" .. project_slug .. ".surge.sh"
-- 	local date_time = os.date("%d/%m/%Y %I:%M %p %a GMT+6")
-- 	local location = "Sharifpur, Gazipur, Dhaka"
-- 	local portfolio_github = "https://github.com/shahjalal-labs/shahjalal-portfolio-v2"
-- 	local portfolio_live = "http://shahjalal-labs.surge.sh"
-- 	local linkedin = "https://www.linkedin.com/in/shahjalal-labs/"
-- 	local facebook = "https://www.facebook.com/shahjalal.labs"
-- 	local twitter = "https://x.com/shahjalal_labs"
--
-- 	local readme_path = cwd .. "/README.md"
-- 	local cname_path = cwd .. "/public/CNAME"
-- 	local developer_md_path = cwd .. "/developer.md"
--
-- 	vim.ui.input({ prompt = "Enter the repository name: ", default = base_name }, function(input)
-- 		local repo_name = input or base_name
-- 		local github_url = "https://github.com/shahjalal-labs/" .. repo_name
--
-- 		vim.cmd("redrawstatus")
-- 		vim.cmd("echo 'Initializing repository...'")
--
-- 		local readme_content = string.format(
-- 			[[# 🌟 %s
--
-- ## 📂 Project Information
--
-- | 📝 **Detail**           | 📌 **Value**                                                              |
-- |------------------------|---------------------------------------------------------------------------|
-- | 🔗 **GitHub URL**       | [%s](%s)                                                                  |
-- | 🌐 **Live Site**        | [%s](%s)                                                                  |
-- | 💻 **Portfolio GitHub** | [%s](%s)                                                                  |
-- | 🌐 **Portfolio Live**   | [%s](%s)                                                                  |
-- | 📁 **Directory**        | `%s`                                                                      |
-- | 📅 **Created On**       | `%s`                                                                      |
-- | 📍 **Location**         | %s                                                                        |
-- | 💼 **LinkedIn**         | [%s](%s)                                                                  |
-- | 📘 **Facebook**         | [%s](%s)                                                                  |
-- | ▶️ **Twitter**          | [%s](%s)                                                                  |
--
-- ---
-- ### `Developer info:`
-- ![Developer Info:](https://i.ibb.co/kVR4YmrX/developer-Info-Github-Banner.png)
--
-- > 🚀
-- > 🧠
-- ]],
-- 			repo_name,
-- 			github_url,
-- 			github_url,
-- 			live_site,
-- 			live_site,
-- 			portfolio_github,
-- 			portfolio_github,
-- 			portfolio_live,
-- 			portfolio_live,
-- 			cwd,
-- 			date_time,
-- 			location,
-- 			linkedin,
-- 			linkedin,
-- 			facebook,
-- 			facebook,
-- 			twitter,
-- 			twitter
-- 		)
--
-- 		local readme_existing = ""
-- 		if vim.fn.filereadable(readme_path) == 1 then
-- 			readme_existing = table.concat(vim.fn.readfile(readme_path), "\n")
-- 		end
-- 		local final_readme = readme_content .. "\n" .. readme_existing
--
-- 		local readme_file = io.open(readme_path, "w")
-- 		readme_file:write(final_readme)
-- 		readme_file:close()
--
-- 		os.execute("mkdir -p " .. cwd .. "/public")
-- 		local cname_file = io.open(cname_path, "w")
-- 		cname_file:write(project_slug .. ".surge.sh\n")
-- 		cname_file:close()
--
-- 		local developer_md_file = io.open(developer_md_path, "w")
-- 		developer_md_file:write("-- Your developer.md content here --")
-- 		developer_md_file:close()
--
-- 		local function run_git(cmd)
-- 			local output = vim.fn.system(cmd)
-- 			if vim.v.shell_error ~= 0 then
-- 				vim.notify("Git error: " .. output, vim.log.levels.ERROR)
-- 				return false
-- 			end
-- 			return true
-- 		end
--
-- 		if not run_git("git init") then
-- 			return
-- 		end
-- 		if not run_git("git add .") then
-- 			return
-- 		end
-- 		if not run_git("git commit -m 'Initial commit'") then
-- 			return
-- 		end
-- 		if not run_git("git branch -M main") then
-- 			return
-- 		end
--
-- 		local create_repo_cmd = string.format("gh repo create %s --public --source=. --remote=origin --push", repo_name)
-- 		if not run_git(create_repo_cmd) then
-- 			return
-- 		end
--
-- 		vim.cmd("redrawstatus")
-- 		vim.notify("Repository created and pushed successfully!", vim.log.levels.INFO)
--
-- 		os.execute("xdg-open " .. github_url)
-- 		vim.cmd("echo 'GitHub repository created and pushed!'")
--
-- 		if is_react_project() then
-- 			update_index_html_title(project_slug)
--
-- 			if not tmux_pane_exists(2) then
-- 				os.execute("tmux split-window -h")
-- 			end
-- 			if not tmux_pane_exists(3) then
-- 				os.execute("tmux split-window -v")
-- 			end
--
-- 			local surge_cmd = string.format(
-- 				"bun i && bun run build && cp dist/index.html dist/200.html && surge ./dist && xdg-open https://%s.surge.sh",
-- 				project_slug
-- 			)
--
-- 			send_to_tmux(2, surge_cmd)
-- 			send_to_tmux(3, "npx vite --open")
-- 			vim.notify("React project setup completed with Surge + Vite", vim.log.levels.INFO)
-- 		end
-- 	end)
-- end
-- local M = {}
--
-- -- 🔁 Adjust this path if your restore function is elsewhere
-- local restore_tmux_layouts = require("sj.core.custom.TmuxZshCli.tmuxZsh2").restore_tmux_layouts
--
-- function M.createGitRepoAndPushToGithub()
-- 	-- 🧠 Step 1: Ensure pane 2 exists and run `bun build && surge`
-- 	local pane2_exists = vim.fn.system("tmux list-panes -F '#P' | grep -q '^2$' && echo 'yes' || echo 'no'")
-- 	if pane2_exists:match("no") then
-- 		os.execute("tmux split-window -v -t 0") -- split below pane 0
-- 	end
-- 	os.execute("tmux send-keys -t 2 'bun build && surge' Enter")
--
-- 	-- 🧠 Step 2: Ensure pane 3 exists and run `bunx vite --open`
-- 	local pane3_exists = vim.fn.system("tmux list-panes -F '#P' | grep -q '^3$' && echo 'yes' || echo 'no'")
-- 	if pane3_exists:match("no") then
-- 		os.execute("tmux split-window -h -t 1") -- split right of pane 1
-- 	end
-- 	os.execute("tmux send-keys -t 3 'bunx vite --open' Enter")
--
-- 	-- ♻️ Step 3: Restore Tmux layout
-- 	restore_tmux_layouts()
--
-- 	-- 🎯 Step 4: Keep focus on Neovim pane
-- 	os.execute("tmux select-pane -t 0")
-- end
--
-- vim.keymap.set("n", "<leader>gk", createGitRepoAndPushToGithub, { noremap = true, silent = true })
--w: updated
--p: ╭──────────── Block Start ────────────╮
-- githubRepoGenerateAndPush.lua

local M = {}

-- 🔁 Util functions
local function slugify(str)
	return str:lower():gsub("[^%w]", "")
end

local function strip_marker(name)
	local lower = name:lower()
	for _, marker in ipairs({ "client", "server" }) do
		if lower:sub(-#marker) == marker then
			local sep_pos = #name - #marker
			if name:sub(sep_pos, sep_pos) == "-" or name:sub(sep_pos, sep_pos) == "_" then
				return name:sub(1, sep_pos - 1)
			else
				return name:sub(1, #name - #marker)
			end
		end
		if lower:sub(1, #marker) == marker then
			local sep_pos = #marker + 1
			if name:sub(sep_pos, sep_pos) == "-" or name:sub(sep_pos, sep_pos) == "_" then
				return name:sub(sep_pos + 1)
			else
				return name:sub(#marker + 1)
			end
		end
	end
	return name
end

local function is_react_project()
	local package_json = vim.fn.getcwd() .. "/package.json"
	if vim.fn.filereadable(package_json) == 1 then
		local content = table.concat(vim.fn.readfile(package_json), "\n")
		return content:match('"react"%s*:') ~= nil
	end
	return false
end

local function update_index_html_title(slug)
	local path = vim.fn.getcwd() .. "/index.html"
	if vim.fn.filereadable(path) == 1 then
		local content = vim.fn.readfile(path)
		for i, line in ipairs(content) do
			if line:match("<title>") then
				content[i] = "    <title>" .. slug .. "</title>"
				break
			end
		end
		vim.fn.writefile(content, path)
	end
end

local function tmux_pane_exists(pane_num)
	local panes = vim.fn.systemlist("tmux list-panes -F '#P'")
	for _, pane in ipairs(panes) do
		if tonumber(pane) == pane_num then
			return true
		end
	end
	return false
end

local function send_to_tmux(pane, cmd)
	local full = string.format("tmux send-keys -t %d '%s' Enter", pane, cmd)
	os.execute(full)
end

local function restore_tmux_layouts()
	os.execute("tmux select-layout tiled")
	os.execute("tmux select-pane -t 0")
end

function M.createGitRepoAndPushToGithub()
	local cwd = vim.fn.getcwd()
	local folder = vim.fn.fnamemodify(cwd, ":t")
	local base = strip_marker(folder)
	local slug = slugify(base)
	local date = os.date("%d/%m/%Y %I:%M %p %a GMT+6")
	local location = "Sharifpur, Gazipur, Dhaka"
	local site = "https://" .. slug .. ".surge.sh"
	local git_url = "https://github.com/shahjalal-labs/" .. base

	local readme = cwd .. "/README.md"
	local cname = cwd .. "/public/CNAME"
	local dev_md = cwd .. "/developer.md"

	vim.ui.input({ prompt = "Enter repository name: ", default = base }, function(repo)
		local repo_name = repo or base
		local final_url = "https://github.com/shahjalal-labs/" .. repo_name

		local md = string.format(
			[[
# 🌟 %s

## 📂 Project Information

| 📝 **Detail**           | 📌 **Value**                                                              |
|------------------------|---------------------------------------------------------------------------|
| 🔗 **GitHub URL**       | [%s](%s)                                                                  |
| 🌐 **Live Site**        | [%s](%s)                                                                  |
| 💻 **Portfolio GitHub** | [Portfolio](https://github.com/shahjalal-labs/shahjalal-portfolio-v2)     |
| 🌐 **Portfolio Live**   | [Portfolio Live](http://shahjalal-labs.surge.sh)                          |
| 📁 **Directory**        | `%s`                                                                      |
| 📅 **Created On**       | `%s`                                                                      |
| 📍 **Location**         | %s                                                                        |
| 💼 **LinkedIn**         | [LinkedIn](https://www.linkedin.com/in/shahjalal-labs/)                   |
| 📘 **Facebook**         | [Facebook](https://www.facebook.com/shahjalal.labs)                       |
| ▶️ **Twitter**          | [Twitter](https://x.com/shahjalal_labs)                                   |

---
### `Developer info:`
![Developer Info](https://i.ibb.co/kVR4YmrX/developer-Info-Github-Banner.png)
]],
			repo_name,
			final_url,
			final_url,
			site,
			site,
			cwd,
			date,
			location
		)

		vim.fn.writefile({ md }, readme)
		os.execute("mkdir -p " .. cwd .. "/public")
		vim.fn.writefile({ slug .. ".surge.sh" }, cname)
		vim.fn.writefile({ "-- Developer notes" }, dev_md)

		local function run(cmd)
			local out = vim.fn.system(cmd)
			if vim.v.shell_error ~= 0 then
				vim.notify("Git error: " .. out, vim.log.levels.ERROR)
				return false
			end
			return true
		end

		if not run("git init") then
			return
		end
		if not run("git add .") then
			return
		end
		if not run("git commit -m 'Initial commit'") then
			return
		end
		if not run("git branch -M main") then
			return
		end
		if not run(string.format("gh repo create %s --public --source=. --remote=origin --push", repo_name)) then
			return
		end

		vim.notify("✅ GitHub repository created and pushed!", vim.log.levels.INFO)
		os.execute("xdg-open " .. final_url)

		if is_react_project() then
			update_index_html_title(slug)

			if not tmux_pane_exists(2) then
				os.execute("tmux split-window -h")
			end
			if not tmux_pane_exists(3) then
				os.execute("tmux split-window -v")
			end

			send_to_tmux(
				2,
				"bun i && bun run build && cp dist/index.html dist/200.html && surge ./dist && xdg-open " .. site
			)
			send_to_tmux(3, "bunx vite --open")

			restore_tmux_layouts()
			vim.notify("🚀 React + Surge + Vite setup complete", vim.log.levels.INFO)
		end
	end)
end

-- Optional keybinding
vim.keymap.set("n", "<leader>gk", M.createGitRepoAndPushToGithub, { noremap = true, silent = true })

return M
