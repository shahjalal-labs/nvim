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

### `Developer info:`

![Developer Info:](https://i.ibb.co/kVR4YmrX/developer-Info-Github-Banner.png)

```
