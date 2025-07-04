vim.keymap.set("n", "<leader>sw", function()
	local cwd = vim.fn.getcwd()
	local screenshots_dir = cwd .. "/src/assets/screenshots"
	local readme_path = cwd .. "/README.md"

	-- Ensure screenshots directory exists
	vim.fn.mkdir(screenshots_dir, "p")

	-- Compose the bash screenshot command
	local bash_cmd = string.format(
		[[
    f="%s/ss-$(LC_TIME=C date +%%I-%%M-%%S-%%p_%%d-%%m-%%y).png";
    grim -g "$(slurp)" "$f" &&
    wl-copy --type image/png < "$f" &&
    echo "![Screenshot](src/assets/screenshots/$(basename "$f"))"
  ]],
		screenshots_dir
	)

	-- Run bash command and capture markdown image line
	local output = vim.fn.systemlist({ "bash", "-c", bash_cmd })

	if output and #output > 0 then
		local md_line = output[1]

		-- Append markdown line to README.md
		local file = io.open(readme_path, "a")
		if file then
			file:write("\n" .. md_line .. "\n")
			file:close()
			print("🖼️ Screenshot saved and appended to README.md")
		else
			print("❌ Failed to open README.md for appending")
		end
	else
		print("❌ Screenshot failed")
	end
end, { desc = "Area select screenshot + append markdown to README.md" })

--
vim.api.nvim_create_user_command("OpenInCanary", function()
	local current_file = vim.fn.expand("%:p")
	local fallback = vim.fn.expand("~/fallback.html")
	local chrome_bin = "google-chrome-canary"

	local check_command = [[
    curl --silent http://127.0.0.1:9222/json | grep -iq "chatgpt"
  ]]

	vim.fn.jobstart({ "sh", "-c", check_command }, {
		stdout_buffered = true,
		on_exit = function(_, code)
			local target = (code == 0) and current_file or fallback
			local msg = (code == 0) and "✅ ChatGPT tab found — opening current file"
				or "❌ No ChatGPT tab — opening fallback"

			vim.notify(msg, vim.log.levels.INFO)
			vim.fn.jobstart({ chrome_bin, target }, { detach = true })
		end,
		on_stderr = function(_, data)
			if data then
				print("❌ Shell error: ", vim.inspect(data))
			end
		end,
	})
end, {})

vim.keymap.set("n", "<leader>gw", "<cmd>OpenInCanary<CR>", {
	desc = "Open current file if any ChatGPT tab is open",
})
