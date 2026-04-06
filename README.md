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

### Build & packaging

| Dependency | URL | License |
|---|---|---|
| Nix | https://github.com/NixOS/nix | LGPL-2.1 |
| nixpkgs | https://github.com/NixOS/nixpkgs | MIT |
| nixvim | https://github.com/nix-community/nixvim | MIT |
| nix-appimage | https://github.com/ralismark/nix-appimage | MIT |

### CI - GitHub Actions

| Action | URL | License |
|---|---|---|
| cachix/install-nix-action | https://github.com/cachix/install-nix-action | Apache-2.0 |
| DeterminateSystems/magic-nix-cache-action | https://github.com/DeterminateSystems/magic-nix-cache-action | MIT |
| actions/checkout | https://github.com/actions/checkout | MIT |
| actions/upload-artifact | https://github.com/actions/upload-artifact | MIT |
| softprops/action-gh-release | https://github.com/softprops/action-gh-release | MIT |
| peter-evans/create-pull-request | https://github.com/peter-evans/create-pull-request | MIT |

### Core

| Plugin | URL | License |
|---|---|---|
| Neovim | https://github.com/neovim/neovim | Apache-2.0 |
| LazyVim | https://github.com/LazyVim/LazyVim | Apache-2.0 |
| lazy.nvim | https://github.com/folke/lazy.nvim | Apache-2.0 |

### Plugins - UI

| Plugin | URL | License |
|---|---|---|
| tokyonight.nvim | https://github.com/folke/tokyonight.nvim | Apache-2.0 |
| vscode.nvim | https://github.com/Mofiqul/vscode.nvim | MIT |
| onedark.nvim | https://github.com/navarasu/onedark.nvim | MIT |
| bufferline.nvim | https://github.com/akinsho/bufferline.nvim | GPL-3.0 |
| lualine.nvim | https://github.com/nvim-lualine/lualine.nvim | MIT |
| neo-tree.nvim | https://github.com/nvim-neo-tree/neo-tree.nvim | MIT |
| noice.nvim | https://github.com/folke/noice.nvim | Apache-2.0 |
| nui.nvim | https://github.com/MunifTanjim/nui.nvim | MIT |
| nvim-notify | https://github.com/rcarriga/nvim-notify | MIT |
| nvim-web-devicons | https://github.com/nvim-tree/nvim-web-devicons | Apache-2.0 |
| mini.nvim | https://github.com/echasnovski/mini.nvim | MIT |
| render-markdown.nvim | https://github.com/MeanderingProgrammer/render-markdown.nvim | MIT |
| indent-blankline.nvim | https://github.com/lukas-reineke/indent-blankline.nvim | MIT |

### Plugins - Editor

| Plugin | URL | License |
|---|---|---|
| telescope.nvim | https://github.com/nvim-telescope/telescope.nvim | MIT |
| telescope-fzf-native.nvim | https://github.com/nvim-telescope/telescope-fzf-native.nvim | MIT |
| fzf-lua | https://github.com/ibhagwan/fzf-lua | MIT |
| flash.nvim | https://github.com/folke/flash.nvim | Apache-2.0 |
| which-key.nvim | https://github.com/folke/which-key.nvim | Apache-2.0 |
| trouble.nvim | https://github.com/folke/trouble.nvim | Apache-2.0 |
| todo-comments.nvim | https://github.com/folke/todo-comments.nvim | Apache-2.0 |
| persistence.nvim | https://github.com/folke/persistence.nvim | Apache-2.0 |
| harpoon2 | https://github.com/ThePrimeagen/harpoon | MIT |
| nvim-surround | https://github.com/kylechui/nvim-surround | MIT |
| yanky.nvim | https://github.com/gbprod/yanky.nvim | MIT |
| refactoring.nvim | https://github.com/ThePrimeagen/refactoring.nvim | MIT |
| inc-rename.nvim | https://github.com/smjonas/inc-rename.nvim | MIT |
| plenary.nvim | https://github.com/nvim-lua/plenary.nvim | MIT |

### Plugins - LSP & Completion

| Plugin | URL | License |
|---|---|---|
| nvim-lspconfig | https://github.com/neovim/nvim-lspconfig | Apache-2.0 |
| mason.nvim | https://github.com/williamboman/mason.nvim | Apache-2.0 |
| mason-lspconfig.nvim | https://github.com/williamboman/mason-lspconfig.nvim | Apache-2.0 |
| nvim-cmp | https://github.com/hrsh7th/nvim-cmp | MIT |
| cmp-nvim-lsp | https://github.com/hrsh7th/cmp-nvim-lsp | MIT |
| cmp-buffer | https://github.com/hrsh7th/cmp-buffer | MIT |
| cmp-path | https://github.com/hrsh7th/cmp-path | MIT |
| LuaSnip | https://github.com/L3MON4D3/LuaSnip | Apache-2.0 |
| cmp_luasnip | https://github.com/saadparwaiz1/cmp_luasnip | Apache-2.0 |
| friendly-snippets | https://github.com/rafamadriz/friendly-snippets | MIT |
| conform.nvim | https://github.com/stevearc/conform.nvim | MIT |
| nvim-lint | https://github.com/mfussenegger/nvim-lint | MIT |

### Plugins - Treesitter

| Plugin | URL | License |
|---|---|---|
| nvim-treesitter | https://github.com/nvim-treesitter/nvim-treesitter | Apache-2.0 |
| nvim-treesitter-textobjects | https://github.com/nvim-treesitter/nvim-treesitter-textobjects | Apache-2.0 |
| nvim-treesitter-context | https://github.com/nvim-treesitter/nvim-treesitter-context | GPL-3.0 |

### Plugins - Git

| Plugin | URL | License |
|---|---|---|
| gitsigns.nvim | https://github.com/lewis6991/gitsigns.nvim | MIT |
| diffview.nvim | https://github.com/sindrets/diffview.nvim | GPL-3.0 |
| neogit | https://github.com/NeogitOrg/neogit | MIT |
| vim-fugitive | https://github.com/tpope/vim-fugitive | Vim[1] |
| lazygit.nvim | https://github.com/kdheepak/lazygit.nvim | MIT |

### Plugins - Languages (Python / C++ / Go / CMake)

| Plugin | URL | License |
|---|---|---|
| nvim-dap | https://github.com/mfussenegger/nvim-dap | MIT |
| nvim-dap-ui | https://github.com/rcarriga/nvim-dap-ui | MIT |
| nvim-dap-virtual-text | https://github.com/theHamsta/nvim-dap-virtual-text | GPL-3.0 |
| nvim-dap-python | https://github.com/mfussenegger/nvim-dap-python | GPL-3.0 |
| nvim-dap-go | https://github.com/leoluz/nvim-dap-go | MIT |
| clangd_extensions.nvim | https://github.com/p00f/clangd_extensions.nvim | MIT |
| cmake-tools.nvim | https://github.com/Civitasv/cmake-tools.nvim | GPL-3.0 |

### Plugins - Testing & Tasks

| Plugin | URL | License |
|---|---|---|
| neotest | https://github.com/nvim-neotest/neotest | MIT |
| nvim-nio | https://github.com/nvim-neotest/nvim-nio | MIT |
| neotest-python | https://github.com/nvim-neotest/neotest-python | MIT |
| neotest-golang | https://github.com/fredrikaverpil/neotest-golang | MIT |
| overseer.nvim | https://github.com/stevearc/overseer.nvim | MIT |
| toggleterm.nvim | https://github.com/akinsho/toggleterm.nvim | MIT |
| grug-far.nvim | https://github.com/MagicDuck/grug-far.nvim | MIT |
| lazydev.nvim | https://github.com/folke/lazydev.nvim | Apache-2.0 |
| nvim-ts-autotag | https://github.com/windwp/nvim-ts-autotag | MIT |
| venv-selector.nvim | https://github.com/linux-cultist/venv-selector.nvim | MIT |

### System tools (bundled via Nix)

| Tool | URL | License |
|---|---|---|
| StyLua | https://github.com/JohnnyMorganz/StyLua | MIT |
| nixfmt | https://github.com/serokell/nixfmt | Apache-2.0 |
| Prettier | https://github.com/prettier/prettier | MIT |
| ShellCheck | https://github.com/koalaman/shellcheck | GPL-3.0 |
| Pyright | https://github.com/microsoft/pyright | MIT |
| Ruff | https://github.com/astral-sh/ruff | MIT |
| debugpy | https://github.com/microsoft/debugpy | MIT |
| clang-tools (clangd, clang-format) | https://github.com/llvm/llvm-project | Apache-2.0 with LLVM exceptions |
| LLDB | https://github.com/llvm/llvm-project | Apache-2.0 with LLVM exceptions |
| CMake | https://github.com/Kitware/CMake | BSD-3-Clause |
| Bear | https://github.com/rizsotto/Bear | GPL-3.0 |
| neocmakelsp | https://github.com/Decodetalkers/neocmakelsp | MIT |
| gopls | https://github.com/golang/tools | BSD-3-Clause |
| Delve | https://github.com/go-delve/delve | MIT |
| gofumpt | https://github.com/mvdan/gofumpt | BSD-3-Clause |
| gotools | https://github.com/golang/tools | BSD-3-Clause |
| Git | https://git-scm.com | GPL-2.0 |
| lazygit | https://github.com/jesseduffield/lazygit | MIT |
| fzf | https://github.com/junegunn/fzf | MIT |
| bat | https://github.com/sharkdp/bat | Apache-2.0 OR MIT |
| ripgrep | https://github.com/BurntSushi/ripgrep | Unlicense OR MIT |
| fd | https://github.com/sharkdp/fd | Apache-2.0 OR MIT |
| GCC | https://gcc.gnu.org | GPL-3.0 with GCC Runtime Library Exception |

---

[1] vim-fugitive uses the [Vim license](https://github.com/tpope/vim-fugitive/blob/master/LICENSE), a charityware license compatible with the GPL.
