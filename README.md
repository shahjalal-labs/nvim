# 🌟 nvim

## 📂 Project Information

| 📝 **Detail**           | 📌 **Value**                                                                                                         |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------- |
| 🔗 **GitHub URL**       | [https://github.com/shahjalal-labs/nvim](https://github.com/shahjalal-labs/nvim)                                     |
| 🌐 **Live Site**        | [http://shahjalal-mern.surge.sh](http://shahjalal-mern.surge.sh)                                                     |
| 💻 **Portfolio GitHub** | [https://github.com/shahjalal-labs/shahjalal-portfolio-v2](https://github.com/shahjalal-labs/shahjalal-portfolio-v2) |
| 🌐 **Portfolio Live**   | [http://shahjalal-mern.surge.sh](http://shahjalal-mern.surge.sh)                                                     |
| 📁 **Directory**        | `/home/sj/.config/nvim`                                                                                              |
| 👤 **Username**         | `sj`                                                                                                                 |
| 📅 **Created On**       | `04/07/2025 09:28 অপরাহ্ণ শুক্র GMT+6`                                                                               |
| 📍 **Location**         | Sharifpur, Gazipur, Dhaka                                                                                            |
| 💼 **LinkedIn**         | [https://www.linkedin.com/in/shahjalal-mern/](https://www.linkedin.com/in/shahjalal-mern/)                           |
| 📘 **Facebook**         | [https://www.facebook.com/profile.php?id=61556383702555](https://www.facebook.com/profile.php?id=61556383702555)     |
| ▶️ **YouTube**          | [https://www.youtube.com/@muhommodshahjalal9811](https://www.youtube.com/@muhommodshahjalal9811)                     |

---

# Neovim Custom Configuration by sj

Welcome to my personal **Neovim configuration repository**! This setup provides a **modern, powerful, and highly customizable Neovim environment** tailored for advanced development workflows, especially in web development (JS/TS, MERN stack, etc.), terminal productivity, Git automation, and more.

---

## Introduction

This repository contains a comprehensive and modular Neovim configuration structured for flexibility, extensibility, and performance. It leverages the latest Neovim Lua API, modern plugins (managed via `lazy.nvim`), and custom utility scripts that streamline coding, Git operations, terminal integration, and project management.

The main goals of this configuration are:

- **Modular architecture:** Easy to maintain and extend with separate files for different features and language supports.
- **Powerful Git integration:** Multiple custom modules automate Git workflows, repo creation, README generation, and more.
- **Enhanced JS/TS support:** Advanced tooling for JavaScript and TypeScript development, including JSX support.
- **Terminal and shell integration:** Tight integration with Tmux and Zsh for seamless terminal workflows inside Neovim.
- **UI/UX improvements:** Custom modes, scroll modes, color schemes, status lines, and a rich assortment of plugins for productivity.

---

## Project Structure Overview

```bash
.
├── init.lua                     # Main entry point for Neovim configuration
├── lazy-lock.json               # Lock file for lazy.nvim plugin manager
├── lua
│   └── sj                      # Root Lua namespace for custom configs
│       ├── core                # Core config files (options, keymaps, utils)
│       │   ├── custom          # Custom modules (Git automation, custom modes, etc.)
│       │   ├── keymaps.lua     # Key mappings
│       │   ├── options.lua     # Neovim options and settings
│       │   └── utils.lua       # Utility functions
│       ├── lazy.lua            # Plugin manager setup (lazy.nvim)
│       └── plugins             # Plugin configuration files
│           ├── lsp             # LSP and Mason configurations
│           ├── ...             # Many individual plugin configs (e.g., telescope, nvim-cmp, treesitter)
├── README.md                   # This documentation file
├── readmeGenerateFull.md       # Generated README content (likely automated)
└── structure.md                # Documentation of the repo/project structure

---
```

## Key Highlights

### Core Modules (`lua/sj/core/custom`)

- **Git Automation:**  
  Scripts for automating Git tasks such as cloning repos, auto-pushing changes, generating GitHub repo descriptions, smart copy-paste, and automated README generation.

- **Custom Modes:**  
  Advanced custom modes and scroll modes that enhance Neovim’s behavior beyond defaults.

- **JS/TS Pro Setup:**  
  Dedicated files providing advanced support for JavaScript, TypeScript, and JSX development with custom tooling.

- **Terminal & Shell Integration:**  
  Modules facilitating smooth workflows with Tmux and Zsh inside Neovim, including command sending and terminal buffer management.

### Plugins (`lua/sj/plugins`)

- Well-curated set of plugins for coding productivity, UI enhancements, Git integration, language servers, syntax highlighting, code completion, and more.

- Examples include: `telescope`, `lualine`, `gitsigns`, `nvim-cmp`, `treesitter`, `noice`, `copilotChat`, `fzf-lua`, and many others.

- Plugin configs are modular, focused on clean setup and performance.

### Configuration Entrypoints

- `init.lua` initializes core settings, loads plugins, and sets up custom keymaps and modes.

- `lazy.lua` handles lazy-loading and management of plugins.

- Core options and mappings are clearly separated for easy adjustments.

---

## How to Use

- Clone the repository into your Neovim config directory (usually `~/.config/nvim`):

  ```bash
  git clone <this-repo-url> ~/.config/nvim
  ```

  ## 🚀 Getting Started After Installation

After cloning the config, follow these steps to get the full experience:

- 🧠 **Open Neovim**  
  Let the plugin manager [`lazy.nvim`](https://github.com/folke/lazy.nvim) automatically install all configured plugins.

- 🛠️ **Explore Keymaps**  
  Check out custom commands and keybindings inside  
  `lua/sj/core/keymaps.lua`.

- 🧬 **Use Git Automation Scripts**  
  Navigate to `lua/sj/core/custom/Git` to leverage automation for:
  - Cloning & pushing repos
  - Generating README/descriptions
  - Smart copy-paste and more

- ⚙️ \*\*
  - Core settings → `lua/sj/core/options.lua`
  - Plugins → `lua/sj/plugins/`
  - Custom logic & modes → `lua/sj/core/custom/`

---

## 🧭 Philosophy

- 🧪 **CLI-first & Automation-minded**  
  Built to maximize terminal power. Uses Lua + shell integrations for a seamless, productive experience.

- 🧱 **Modularity & Clarity**  
  Every feature is split into logical modules. Easy to navigate, extend, or disable.

- 💻 **Modern JS/TS Focus**  
  Includes advanced tooling for JavaScript, TypeScript, React/JSX. Perfect for web developers.

- 🔄 **Up-to-date & Community-powered**  
  Uses actively maintained plugins, best practices, and the latest Neovim APIs.

---

## 🔮 Future Plans

- 🚀 Expand Git automation modules even further.
- 🌐 Add support for more languages & frameworks.
- 🔧 Improve Tmux/Zsh integration and terminal workflows.
- 🎛️ Develop additional **custom modes**, interactive UIs, and dynamic behavior extensions.

---

## 🤝 Contributing

Contributions and suggestions are **very welcome**!

Feel free to:

- 📂 Fork the repo
- 🛠️ Create new features or improvements
- 🔁 Submit pull requests
- 🐞 Report bugs or open issues

---

## 📄 License

This repository is **open-source**. Use it, learn from it, and customize it for your own workflow. No restrictions!

---

## 📬 Want Help?

If you'd like a **developer onboarding guide**, **feature walkthrough**, or a **short summary**,  
**just ask** — happy to generate it for you!

### `Developer info:`

![Developer Info:](https://i.ibb.co/kVR4YmrX/developer-Info-Github-Banner.png)
