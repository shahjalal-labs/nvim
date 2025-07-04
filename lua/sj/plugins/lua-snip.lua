return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local f = ls.function_node

			local function get_file_name()
				local file = vim.fn.expand("%:t") -- Get the file name with extension
				local name = file:match("(.+)%..+$") -- Remove the extension
				return name or "Component" -- Fallback to "Component" if no name found
			end

			ls.add_snippets("typescriptreact", {
				s("cc", {
					f(function()
						local name = get_file_name()
						vim.schedule(function()
							vim.cmd("stopinsert") -- This will exit to normal mode after snippet expansion
						end)
						return {
							"export default function " .. name .. "() {",
							"    return (",
							"        <div>",
							"            " .. name,
							"        </div>",
							"    );",
							"}",
						}
					end),
				}),
			})

			local i = ls.insert_node

			-- HTML template snippet with placeholders for title and link href, final cursor inside the body tag
			ls.add_snippets("html", {
				s("h", {
					t({
						"<!doctype html>",
						'<html lang="en">',
						"  <head>",
						'    <meta charset="UTF-8" />',
						'    <meta name="viewport" content="width=device-width, initial-scale=1.0" />',
						"    <title>",
					}),
					i(3), -- Empty placeholder for title
					t({
						"</title>",
						'    <link rel="stylesheet" href="',
					}),
					i(2), -- Empty placeholder for link href
					t({
						'" />',
						"  </head>",
						"  <body>",
					}),
					i(1), -- Final cursor placement inside the <body> tag
					t({
						"  </body>",
						"</html>",
					}),
				}),
			})

			ls.add_snippets("javascriptreact", {
				s("a", {
					t({ "const " }),
					f(function() -- Removed unused snip parameter
						local filename = vim.fn.expand("%:t:r")
						return filename
					end, {}),
					t({ " = () => {", "  return (", "    <>", "      " }),
					i(1, ""),
					t({ "", "    </>", "  );", "};", "", "export default " }),
					f(function() -- Removed unused snip parameter
						local filename = vim.fn.expand("%:t:r")
						return filename
					end, {}),
					t(";"),
				}),
			})

			ls.add_snippets("typescriptreact", {

				s("a", {

					t({ "const " }),
					f(function() -- Removed unused snip parameter
						local filename = vim.fn.expand("%:t:r")
						return filename
					end, {}),
					t({ " = () => {", "  return (", "    <>" }),
					i(1, ""),
					t({ "", "    </>", "  );", "};", "", "export default " }),
					f(function() -- Removed unused snip parameter
						local filename = vim.fn.expand("%:t:r")
						return filename
					end, {}),
					t(";"),
				}),
			})

			--
			--
			--
			-- local ls = require("luasnip")
			-- local s = ls.snippet
			-- local t = ls.text_node
			-- local i = ls.insert_node
			-- local f = ls.function_node
			--
			-- Common filetypes for React components
			local filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			}

			-- Create the snippet
			local react_component = s("b", {
				t({ "const " }),
				f(function()
					local filename = vim.fn.expand("%:t:r")
					return filename
				end, {}),
				f(function()
					-- local ext = vim.fn.expand("%:e")
					--[[ if ext == "tsx" or ext == "ts" then
						return ": React.FC"
					end ]]
					return ""
				end, {}),
				t({ " = () => {", "  return (", "    <div>", "      " }),
				i(1, ""),
				t({ "", "    </div>", "  );", "};", "", "export default " }),
				f(function()
					local filename = vim.fn.expand("%:t:r")
					return filename
				end, {}),
				t(";"),
			})

			-- Add the snippet to all specified filetypes
			for _, ft in ipairs(filetypes) do
				ls.add_snippets(ft, {
					react_component,
				})
			end

			--
			--
			--
			--
			--
			--
			--
			--

			ls.add_snippets("typescript", {
				s("u", {
					t("interface I"),
					i(1, "Name"),
					t({ " {", "    " }),
					i(0),
					t({ "", "}" }),
				}),
			})

			ls.add_snippets("typescriptreact", {
				s("u", {
					t("interface I"),
					i(1, "Name"),
					t({ " {", "    " }),
					i(0),
					t({ "", "}" }),
				}),
			})

			-- Type snippet
			ls.add_snippets("typescript", {
				s("ttype", {
					t("type "), -- separate "type" and "T"
					t("T"),
					i(1, "Name"),
					t(" = {"),
					i(0),
					t("}"),
				}),
			})

			ls.add_snippets("typescript", {
				s("ttype", {
					t("type "), -- separate "type" and "T"
					t("T"),
					i(1, "Name"),
					t(" = {"),
					i(0),
					t("}"),
				}),
			})

			--
			--
			--
			--
			--
			--
			--
			--
			--w: add snippet upper this line this is perhaps config for lua snippet
			-- Optional: You might want these options
			ls.config.set_config({
				history = true,

				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})

			-- Keymaps for jumping between snippet placeholders
			vim.keymap.set({ "i", "s" }, "<M-h>", function()
				if ls.jumpable(1) then
					ls.jump(1)
				end
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end)

			vim.keymap.set({ "i", "s" }, "<M-k>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end)
		end,
	},
}
