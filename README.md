# nvim-airgapped

Reproducible, air-gapped Neovim/LazyVim distribution. All plugins, language servers, formatters, and debuggers are fetched and pinned at build time by Nix. The output is a single self-contained AppImage that runs on any x86\_64 Linux machine with no network access at runtime. User configuration is a separate directory of plain Lua files at `~/.config/nvim`.

---

## Building

### Prerequisites

- Nix with flakes enabled. Add to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

### Build the AppImage

```bash
nix build .#appimage --print-build-logs
cp ./result nvim.AppImage
chmod +x nvim.AppImage
```

First build pulls pre-built binaries from `cache.nixos.org` and compiles
only what is not yet cached. Subsequent builds with an unchanged `flake.lock`
reuse the Nix store and are near-instant.

To inspect what would be fetched without building:

```bash
nix build .#appimage --dry-run
```

### Update plugins

Plugin versions are pinned in `flake.lock`. To update all inputs:

```bash
nix flake update
nix build .#appimage --print-build-logs
```

The monthly CI workflow (`update-plugins.yml`) does this automatically and deploys new releases if the plugins have changed.

---

## Dependencies

> Star counts fetched 2026-04-13. Exact counts (no `~`) came from the GitHub API; counts prefixed with `~` are rounded figures from the GitHub UI.

### Build & packaging

| Dependency | URL | License | Stars | Notes |
|---|---|---|---|---|
| Nix | https://github.com/NixOS/nix | LGPL-2.1 | 16.6k | Official Nix project |
| nixpkgs | https://github.com/NixOS/nixpkgs | MIT | 24.3k | Official Nix package set |
| nixvim | https://github.com/nix-community/nixvim | MIT | 2.8k | nix-community org |
| nix-appimage | https://github.com/ralismark/nix-appimage | MIT | 240 | |

### CI - GitHub Actions

| Action | URL | License | Stars | Notes |
|---|---|---|---|---|
| cachix/install-nix-action | https://github.com/cachix/install-nix-action | Apache-2.0 | 671 | By Cachix (Nix binary cache team) |
| actions/checkout | https://github.com/actions/checkout | MIT | 7.8k | Official GitHub Actions |
| actions/upload-artifact | https://github.com/actions/upload-artifact | MIT | 4.0k | Official GitHub Actions |
| softprops/action-gh-release | https://github.com/softprops/action-gh-release | Apache-2.0 | 5.5k | |
| peter-evans/create-pull-request | https://github.com/peter-evans/create-pull-request | MIT | 2.7k | |

### Core

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| Neovim | https://github.com/neovim/neovim | Apache-2.0 | 98.7k | Official Neovim project |
| LazyVim | https://github.com/LazyVim/LazyVim | Apache-2.0 | 25.8k | By folke |
| lazy.nvim | https://github.com/folke/lazy.nvim | Apache-2.0 | 20.7k | By folke |

### Plugins - UI

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| snacks.nvim | https://github.com/folke/snacks.nvim | Apache-2.0 | 7.4k | LazyVim core (notifications, picker, dashboard); by folke |
| tokyonight.nvim | https://github.com/folke/tokyonight.nvim | Apache-2.0 | 8.0k | By folke |
| vscode.nvim | https://github.com/Mofiqul/vscode.nvim | MIT | 965 | |
| onedark.nvim | https://github.com/navarasu/onedark.nvim | MIT | 2.0k | |
| catppuccin.nvim | https://github.com/catppuccin/nvim | MIT | 7.3k | Referenced by LazyVim extras |
| bufferline.nvim | https://github.com/akinsho/bufferline.nvim | GPL-3.0 | 4.3k | ⚠ Inactive (last push Jan 2025) |
| lualine.nvim | https://github.com/nvim-lualine/lualine.nvim | MIT | 7.9k | |
| neo-tree.nvim | https://github.com/nvim-neo-tree/neo-tree.nvim | MIT | 5.4k | |
| noice.nvim | https://github.com/folke/noice.nvim | Apache-2.0 | 5.7k | By folke |
| nui.nvim | https://github.com/MunifTanjim/nui.nvim | MIT | 2.0k | ⚠ Slow updates (last push Jun 2025) |
| nvim-notify | https://github.com/rcarriga/nvim-notify | MIT | 3.5k | ⚠ Slow updates (last push Sep 2025) |
| nvim-web-devicons | https://github.com/nvim-tree/nvim-web-devicons | Apache-2.0 | 2.6k | Official nvim-tree org |
| mini.nvim | https://github.com/echasnovski/mini.nvim | MIT | 9.0k | All-in-one mini modules suite |
| render-markdown.nvim | https://github.com/MeanderingProgrammer/render-markdown.nvim | MIT | 4.4k | |
| indent-blankline.nvim | https://github.com/lukas-reineke/indent-blankline.nvim | MIT | 4.9k | |

### Plugins - Editor

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| telescope.nvim | https://github.com/nvim-telescope/telescope.nvim | MIT | 19.3k | Official nvim-telescope org |
| telescope-fzf-native.nvim | https://github.com/nvim-telescope/telescope-fzf-native.nvim | MIT | 1.7k | Official nvim-telescope org |
| fzf-lua | https://github.com/ibhagwan/fzf-lua | MIT | 4.2k | |
| flash.nvim | https://github.com/folke/flash.nvim | Apache-2.0 | 4.0k | By folke |
| which-key.nvim | https://github.com/folke/which-key.nvim | Apache-2.0 | 7.1k | By folke |
| trouble.nvim | https://github.com/folke/trouble.nvim | Apache-2.0 | 6.7k | By folke |
| todo-comments.nvim | https://github.com/folke/todo-comments.nvim | Apache-2.0 | 4.1k | By folke |
| persistence.nvim | https://github.com/folke/persistence.nvim | Apache-2.0 | 974 | By folke |
| harpoon2 | https://github.com/ThePrimeagen/harpoon | MIT | 9.0k | By ThePrimeagen |
| nvim-surround | https://github.com/kylechui/nvim-surround | MIT | 4.2k | |
| yanky.nvim | https://github.com/gbprod/yanky.nvim | MIT | 1.2k | |
| refactoring.nvim | https://github.com/ThePrimeagen/refactoring.nvim | MIT | 3.6k | By ThePrimeagen |
| inc-rename.nvim | https://github.com/smjonas/inc-rename.nvim | MIT | 843 | |
| plenary.nvim | https://github.com/nvim-lua/plenary.nvim | MIT | 3.4k | Official nvim-lua org |

### Plugins - LSP & Completion

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| nvim-lspconfig | https://github.com/neovim/nvim-lspconfig | Apache-2.0 | 13.5k | Official Neovim project |
| mason.nvim | https://github.com/williamboman/mason.nvim | Apache-2.0 | 10.2k | ⚠ Transferred to mason-org/mason.nvim |
| mason-lspconfig.nvim | https://github.com/williamboman/mason-lspconfig.nvim | Apache-2.0 | 3.9k | ⚠ Transferred to mason-org/mason-lspconfig.nvim |
| blink.cmp | https://github.com/saghen/blink.cmp | MIT | 6.2k | LazyVim default completion since v14 |
| LuaSnip | https://github.com/L3MON4D3/LuaSnip | Apache-2.0 | 4.3k | |
| friendly-snippets | https://github.com/rafamadriz/friendly-snippets | MIT | 2.7k | |
| conform.nvim | https://github.com/stevearc/conform.nvim | MIT | 5.0k | |
| nvim-lint | https://github.com/mfussenegger/nvim-lint | MIT | 2.7k | |
| ts-comments.nvim | https://github.com/folke/ts-comments.nvim | Apache-2.0 | 549 | LazyVim default; by folke |
| lazydev.nvim | https://github.com/folke/lazydev.nvim | Apache-2.0 | 1.5k | Replaces neodev.nvim; by folke |

### Plugins - Treesitter

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| nvim-treesitter | https://github.com/nvim-treesitter/nvim-treesitter | Apache-2.0 | 13.7k | ⚠ Archived — parsers now ship with Neovim core; official nvim-treesitter org |
| nvim-treesitter-textobjects | https://github.com/nvim-treesitter/nvim-treesitter-textobjects | Apache-2.0 | 2.7k | Official nvim-treesitter org |
| nvim-treesitter-context | https://github.com/nvim-treesitter/nvim-treesitter-context | GPL-3.0 | 3.2k | Official nvim-treesitter org |

### Plugins - Git

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| gitsigns.nvim | https://github.com/lewis6991/gitsigns.nvim | MIT | 6.7k | |
| diffview.nvim | https://github.com/sindrets/diffview.nvim | GPL-3.0 | ~5.5k | |
| neogit | https://github.com/NeogitOrg/neogit | MIT | ~5.3k | |
| vim-fugitive | https://github.com/tpope/vim-fugitive | Vim[1] | ~21.6k | By tpope (Vim legend) |
| lazygit.nvim | https://github.com/kdheepak/lazygit.nvim | MIT | ~2.2k | |

### Plugins - Languages (Python / C++ / Go / CMake)

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| nvim-dap | https://github.com/mfussenegger/nvim-dap | MIT | ~7.1k | |
| nvim-dap-ui | https://github.com/rcarriga/nvim-dap-ui | MIT | ~3.3k | ⚠ Slow updates (last release Mar 2024) |
| nvim-dap-virtual-text | https://github.com/theHamsta/nvim-dap-virtual-text | GPL-3.0 | ~1.1k | |
| nvim-dap-python | https://github.com/mfussenegger/nvim-dap-python | GPL-3.0 | ~704 | |
| nvim-dap-go | https://github.com/leoluz/nvim-dap-go | MIT | ~613 | |
| clangd_extensions.nvim | https://github.com/p00f/clangd_extensions.nvim | MIT | ~577 | |
| cmake-tools.nvim | https://github.com/Civitasv/cmake-tools.nvim | GPL-3.0 | ~533 | |

### Plugins - Testing & Tasks

| Plugin | URL | License | Stars | Notes |
|---|---|---|---|---|
| neotest | https://github.com/nvim-neotest/neotest | MIT | ~3.1k | Official nvim-neotest org |
| nvim-nio | https://github.com/nvim-neotest/nvim-nio | MIT | ~418 | Official nvim-neotest org |
| neotest-python | https://github.com/nvim-neotest/neotest-python | MIT | ~189 | Official nvim-neotest org |
| neotest-golang | https://github.com/fredrikaverpil/neotest-golang | MIT | ~259 | |
| overseer.nvim | https://github.com/stevearc/overseer.nvim | MIT | ~1.9k | |
| toggleterm.nvim | https://github.com/akinsho/toggleterm.nvim | MIT | ~5.5k | |
| grug-far.nvim | https://github.com/MagicDuck/grug-far.nvim | MIT | ~1.9k | Replaces nvim-spectre |
| nvim-ts-autotag | https://github.com/windwp/nvim-ts-autotag | MIT | ~2.1k | |
| venv-selector.nvim | https://github.com/linux-cultist/venv-selector.nvim | MIT | ~755 | |

### System tools (bundled via Nix)

| Tool | URL | License | Stars | Notes |
|---|---|---|---|---|
| StyLua | https://github.com/JohnnyMorganz/StyLua | MIT | ~2.2k | |
| nixfmt | https://github.com/serokell/nixfmt | Apache-2.0 | ~1.5k | Official nixfmt (Serokell / NixOS Foundation) |
| Prettier | https://github.com/prettier/prettier | MIT | ~51.8k | |
| ShellCheck | https://github.com/koalaman/shellcheck | GPL-3.0 | ~39.3k | |
| Pyright | https://github.com/microsoft/pyright | MIT | ~15.4k | By Microsoft |
| Ruff | https://github.com/astral-sh/ruff | MIT | ~47.0k | By Astral |
| debugpy | https://github.com/microsoft/debugpy | MIT | ~2.4k | By Microsoft |
| clang-tools (clangd, clang-format) | https://github.com/llvm/llvm-project | Apache-2.0 with LLVM exceptions | ~37.8k | By LLVM Foundation |
| LLDB | https://github.com/llvm/llvm-project | Apache-2.0 with LLVM exceptions | ~37.8k | By LLVM Foundation |
| CMake | https://github.com/Kitware/CMake | BSD-3-Clause | ~7.9k | By Kitware |
| Bear | https://github.com/rizsotto/Bear | GPL-3.0 | ~6.3k | |
| neocmakelsp | https://github.com/Decodetalkers/neocmakelsp | MIT | ~377 | |
| gopls | https://github.com/golang/tools | BSD-3-Clause | ~7.9k | Official Go team |
| Delve | https://github.com/go-delve/delve | MIT | ~24.7k | |
| gofumpt | https://github.com/mvdan/gofumpt | BSD-3-Clause | ~3.9k | |
| gotools | https://github.com/golang/tools | BSD-3-Clause | ~7.9k | Official Go team |
| Git | https://git-scm.com | GPL-2.0 | — | |
| lazygit | https://github.com/jesseduffield/lazygit | MIT | ~76.3k | |
| fzf | https://github.com/junegunn/fzf | MIT | ~79.4k | By junegunn |
| bat | https://github.com/sharkdp/bat | Apache-2.0 OR MIT | ~58.1k | By sharkdp |
| ripgrep | https://github.com/BurntSushi/ripgrep | Unlicense OR MIT | ~62.3k | |
| fd | https://github.com/sharkdp/fd | Apache-2.0 OR MIT | ~42.5k | By sharkdp |
| GCC | https://gcc.gnu.org | GPL-3.0 with GCC Runtime Library Exception | — | GNU project |

---

[1] vim-fugitive uses the [Vim license](https://github.com/tpope/vim-fugitive/blob/master/LICENSE), a charityware license compatible with the GPL.
