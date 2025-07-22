-- local function slugify(str)
-- 	return str:lower():gsub("[^%w]", "")
-- end
--
-- local function strip_marker(name)
-- 	local lower = name:lower()
-- 	for _, marker in ipairs({ "client", "server" }) do
-- 		-- suffix
-- 		if lower:sub(-#marker) == marker then
-- 			-- also remove dash or underscore before marker if exists
-- 			local sep_pos = #name - #marker
-- 			if name:sub(sep_pos, sep_pos) == "-" or name:sub(sep_pos, sep_pos) == "_" then
-- 				return name:sub(1, sep_pos - 1)
-- 			else
-- 				return name:sub(1, #name - #marker)
-- 			end
-- 		end
-- 		-- prefix
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
-- 	-- Paths
-- 	local readme_path = cwd .. "/README.md"
-- 	local cname_path = cwd .. "/public/CNAME"
-- 	local developer_md_path = cwd .. "/developer.md"
--
-- 	-- Prompt for repo name with default cleaned name
-- 	vim.ui.input({ prompt = "Enter the repository name: ", default = base_name }, function(input)
-- 		local repo_name = input or base_name
-- 		local github_url = "https://github.com/shahjalal-labs/" .. repo_name
--
-- 		vim.cmd("redrawstatus")
-- 		vim.cmd("echo 'Initializing repository...'")
--
-- 		-- 1. Prepare README content with dynamic live_site
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
-- 		-- Append existing README if exists
-- 		local readme_existing = ""
-- 		if vim.fn.filereadable(readme_path) == 1 then
-- 			readme_existing = table.concat(vim.fn.readfile(readme_path), "\n")
-- 		end
-- 		local final_readme = readme_content .. "\n" .. readme_existing
--
-- 		-- Write README.md
-- 		local readme_file = io.open(readme_path, "w")
-- 		readme_file:write(final_readme)
-- 		readme_file:close()
--
-- 		-- 2. Create public/CNAME with the live_site domain only
-- 		-- Ensure public directory exists
-- 		os.execute("mkdir -p " .. cwd .. "/public")
-- 		local cname_file = io.open(cname_path, "w")
-- 		cname_file:write(project_slug .. ".surge.sh\n")
-- 		cname_file:close()
--
-- 		-- 3. Create developer.md with your detailed info (abbreviated here, replace with full)
-- 		local developer_md_content = [[
-- ## <img src="./assets/Banner.jpg" alt="mdshahjalal5" />
--
-- ## 👋 Assalamu Alaikum, I'm **Md. Shahjalal**
--
-- Experienced **MERN Stack Developer** focused on building **scalable**, **maintainable**, and **high-performance** web apps using **modern best practices** and clean architecture.
--
-- - Terminal-first workflow on **Hyprland (Wayland)** & **EndeavourOS**, powered by **Neovim**, **Zsh**, **Tmux**
--
-- 🎯 Open to **Frontend** or **Full-Stack** roles in modern, product-driven teams.
--
-- ---
--
-- # 💻 Tech Stack
--
-- | Category             | Technologies                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
-- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
-- | **Languages**        | ![JavaScript](https://img.shields.io/badge/-JavaScript-333333?style=flat&logo=javascript) ![TypeScript](https://img.shields.io/badge/-TypeScript-3178c6?style=flat&logo=typescript&logoColor=white) ![Markdown](https://img.shields.io/badge/-Markdown-333333?style=flat&logo=markdown) ![Lua](https://img.shields.io/badge/-Lua-2c2d72?style=flat&logo=lua&logoColor=white)                                                                                                                                                                                                                                                                                                                      |
-- | **Frontend**         | ![React](https://img.shields.io/badge/-React-20232a?style=flat&logo=react&logoColor=61dafb) ![React Router](https://img.shields.io/badge/-React_Router-ca4245?style=flat&logo=react-router&logoColor=white) ![TanStack Query](https://img.shields.io/badge/-TanStack_Query-ff4154?style=flat&logo=react-query&logoColor=white) ![Tailwind CSS](https://img.shields.io/badge/-Tailwind-06b6d4?style=flat&logo=tailwind-css)                                                                                                                                                                                                                                                                        |
-- | **Backend**          | ![Node.js](https://img.shields.io/badge/-Node.js-43853d?style=flat&logo=node.js&logoColor=white) ![Express.js](https://img.shields.io/badge/-Express.js-333333?style=flat&logo=express&logoColor=white)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
-- | **Database**         | ![MongoDB](https://img.shields.io/badge/-MongoDB-4ea94b?style=flat&logo=mongodb&logoColor=white)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
-- | **Auth & Hosting**   | ![Firebase](https://img.shields.io/badge/-Firebase-ffca28?style=flat&logo=firebase&logoColor=black) ![JWT](https://img.shields.io/badge/-JWT-000000?style=flat&logo=json-web-tokens&logoColor=white) ![Surge](https://img.shields.io/badge/-Surge-000000?style=flat&logo=vercel&logoColor=white) ![Netlify](https://img.shields.io/badge/-Netlify-00C7B7?style=flat&logo=netlify&logoColor=white)                                                                                                                                                                                                                                                                                                 |
-- | **Design & UI**      | ![Figma](https://img.shields.io/badge/-Figma-333333?style=flat&logo=figma&logoColor=white)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
-- | **Productivity CLI** | ![Neovim](https://img.shields.io/badge/-Neovim-57A143?style=flat&logo=neovim&logoColor=white) ![Tmux](https://img.shields.io/badge/-Tmux-1BB91F?style=flat&logoColor=white) ![Zsh](https://img.shields.io/badge/-Zsh-cccccc?style=flat&logo=gnubash&logoColor=black) ![Kitty](https://img.shields.io/badge/-Kitty-3E3E3E?style=flat&logo=windowsterminal&logoColor=white) ![SurfingKeys](https://img.shields.io/badge/-SurfingKeys-000000?style=flat&logo=firefox&logoColor=white) ![Hyprland](https://img.shields.io/badge/-Hyprland-0078D4?style=flat&logo=wayland&logoColor=white) ![EndeavourOS](https://img.shields.io/badge/-EndeavourOS-7C3AED?style=flat&logo=arch-linux&logoColor=white) |
--
-- ---
--
-- # 📊 GitHub Stats
--
-- ![Shahjalal's GitHub Stats](https://github-readme-stats.vercel.app/api?username=shahjalal-labs&theme=nord&hide_border=false&include_all_commits=false&count_private=false)
--
-- ![Streak Stats](https://github-readme-streak-stats-eight.vercel.app/?user=shahjalal-labs&theme=nord&hide_border=false)
--
-- ![Top Languages](https://github-readme-stats.vercel.app/api/top-langs/?username=shahjalal-labs&theme=nord&hide_border=false&layout=compact)
--
-- ### 🧠 GitHub Contribution Activity
--
-- [![GitHub Activity Graph](https://github-readme-activity-graph.vercel.app/graph?username=shahjalal-labs&theme=react-dark)](https://github.com/ashutosh00710/github-readme-activity-graph)
--
-- ## 📞 Contact Me
--
-- Feel free to reach out or connect with me!
--
-- | 📧 Email                    | 📱 Phone    | 💼 LinkedIn                                                     | 🐙 GitHub                                           |
-- | --------------------------- | ----------- | --------------------------------------------------------------- | --------------------------------------------------- |
-- | muhommodshahjalal@gmail.com | 01540325659 | [LinkedIn Profile](https://www.linkedin.com/in/shahjalal-mern/) | [shahjalal-labs](https://github.com/shahjalal-labs) |
--
-- ---
--
-- ### 🔗 Quick Links
--
-- [![Email](https://img.shields.io/badge/Email-muhommodshahjalal@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:muhommodshahjalal@gmail.com)
-- [![Phone](https://img.shields.io/badge/Call-01540325659-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](tel:01540325659)
-- [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shahjalal-mern/)
-- [![GitHub](https://img.shields.io/badge/GitHub-shahjalal--labs-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/shahjalal-labs)
-- [![Facebook](https://img.shields.io/badge/Facebook-Profile-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/profile.php?id=61556383702555)
--
-- ---
--
-- ### ✍️ Random Dev Quote
--
-- ![](https://quotes-github-readme.vercel.app/api?type=horizontal&theme=dark)
--
-- ---
--
-- <!--
-- Md.Shahjalal – MERN Stack Developer | React, TypeScript, Firebase, Neovim, Hyprland, Tmux | Open-source, CLI productivity, Linux-first
-- -->
-- ]]
--
-- 		local developer_md_file = io.open(developer_md_path, "w")
-- 		developer_md_file:write(developer_md_content)
-- 		developer_md_file:close()
--
-- 		-- Git operations
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
-- 		local open_url_command = string.format("xdg-open %s", github_url) -- Adjust for other OS if needed
-- 		os.execute(open_url_command)
--
-- 		vim.cmd("echo 'GitHub repository created and pushed!'")
-- 	end)
-- end
--
-- -- Map function to <leader>Z (change if you want)
-- vim.keymap.set("n", "<leader>gk", createGitRepoAndPushToGithub, { noremap = true, silent = true })
--w: updated
--p: ╭──────────── Block Start ────────────╮
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
	local package_json_path = vim.fn.getcwd() .. "/package.json"
	if vim.fn.filereadable(package_json_path) == 1 then
		local content = table.concat(vim.fn.readfile(package_json_path), "\n")
		return content:match('"react"%s*:') ~= nil
	end
	return false
end

local function update_index_html_title(slug)
	local html_path = vim.fn.getcwd() .. "/index.html"
	if vim.fn.filereadable(html_path) == 1 then
		local content = vim.fn.readfile(html_path)
		for i, line in ipairs(content) do
			if line:match("<title>") then
				content[i] = "    <title>" .. slug .. "</title>"
				break
			end
		end
		vim.fn.writefile(content, html_path)
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
	local full_cmd = string.format("tmux send-keys -t %d '%s' Enter", pane, cmd)
	os.execute(full_cmd)
end

local function createGitRepoAndPushToGithub()
	local cwd = vim.fn.getcwd()
	local folder_name = vim.fn.fnamemodify(cwd, ":t")
	local base_name = strip_marker(folder_name)
	local project_slug = slugify(base_name)
	local live_site = "https://" .. project_slug .. ".surge.sh"
	local date_time = os.date("%d/%m/%Y %I:%M %p %a GMT+6")
	local location = "Sharifpur, Gazipur, Dhaka"
	local portfolio_github = "https://github.com/shahjalal-labs/shahjalal-portfolio-v2"
	local portfolio_live = "http://shahjalal-labs.surge.sh"
	local linkedin = "https://www.linkedin.com/in/shahjalal-labs/"
	local facebook = "https://www.facebook.com/shahjalal.labs"
	local twitter = "https://x.com/shahjalal_labs"

	local readme_path = cwd .. "/README.md"
	local cname_path = cwd .. "/public/CNAME"
	local developer_md_path = cwd .. "/developer.md"

	vim.ui.input({ prompt = "Enter the repository name: ", default = base_name }, function(input)
		local repo_name = input or base_name
		local github_url = "https://github.com/shahjalal-labs/" .. repo_name

		vim.cmd("redrawstatus")
		vim.cmd("echo 'Initializing repository...'")

		local readme_content = string.format(
			[[# 🌟 %s

## 📂 Project Information

| 📝 **Detail**           | 📌 **Value**                                                              |
|------------------------|---------------------------------------------------------------------------|
| 🔗 **GitHub URL**       | [%s](%s)                                                                  |
| 🌐 **Live Site**        | [%s](%s)                                                                  |
| 💻 **Portfolio GitHub** | [%s](%s)                                                                  |
| 🌐 **Portfolio Live**   | [%s](%s)                                                                  |
| 📁 **Directory**        | `%s`                                                                      |
| 📅 **Created On**       | `%s`                                                                      |
| 📍 **Location**         | %s                                                                        |
| 💼 **LinkedIn**         | [%s](%s)                                                                  |
| 📘 **Facebook**         | [%s](%s)                                                                  |
| ▶️ **Twitter**          | [%s](%s)                                                                  |

---
### `Developer info:`
![Developer Info:](https://i.ibb.co/kVR4YmrX/developer-Info-Github-Banner.png)

> 🚀 
> 🧠 
]],
			repo_name,
			github_url,
			github_url,
			live_site,
			live_site,
			portfolio_github,
			portfolio_github,
			portfolio_live,
			portfolio_live,
			cwd,
			date_time,
			location,
			linkedin,
			linkedin,
			facebook,
			facebook,
			twitter,
			twitter
		)

		local readme_existing = ""
		if vim.fn.filereadable(readme_path) == 1 then
			readme_existing = table.concat(vim.fn.readfile(readme_path), "\n")
		end
		local final_readme = readme_content .. "\n" .. readme_existing

		local readme_file = io.open(readme_path, "w")
		readme_file:write(final_readme)
		readme_file:close()

		os.execute("mkdir -p " .. cwd .. "/public")
		local cname_file = io.open(cname_path, "w")
		cname_file:write(project_slug .. ".surge.sh\n")
		cname_file:close()

		local developer_md_file = io.open(developer_md_path, "w")
		developer_md_file:write("-- Your developer.md content here --")
		developer_md_file:close()

		local function run_git(cmd)
			local output = vim.fn.system(cmd)
			if vim.v.shell_error ~= 0 then
				vim.notify("Git error: " .. output, vim.log.levels.ERROR)
				return false
			end
			return true
		end

		if not run_git("git init") then
			return
		end
		if not run_git("git add .") then
			return
		end
		if not run_git("git commit -m 'Initial commit'") then
			return
		end
		if not run_git("git branch -M main") then
			return
		end

		local create_repo_cmd = string.format("gh repo create %s --public --source=. --remote=origin --push", repo_name)
		if not run_git(create_repo_cmd) then
			return
		end

		vim.cmd("redrawstatus")
		vim.notify("Repository created and pushed successfully!", vim.log.levels.INFO)

		os.execute("xdg-open " .. github_url)
		vim.cmd("echo 'GitHub repository created and pushed!'")

		if is_react_project() then
			update_index_html_title(project_slug)

			if not tmux_pane_exists(2) then
				os.execute("tmux split-window -h")
			end
			if not tmux_pane_exists(3) then
				os.execute("tmux split-window -v")
			end

			local surge_cmd = string.format(
				"bun i && bun run build && cp dist/index.html dist/200.html && surge ./dist && xdg-open https://%s.surge.sh",
				project_slug
			)

			send_to_tmux(2, surge_cmd)
			send_to_tmux(3, "npx vite --open")
			vim.notify("React project setup completed with Surge + Vite", vim.log.levels.INFO)
		end
	end)
end

vim.keymap.set("n", "<leader>gk", createGitRepoAndPushToGithub, { noremap = true, silent = true })
