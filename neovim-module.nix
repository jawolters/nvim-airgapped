# nixvim module - declares every plugin as a Nix package.
# nixvim generates a wrappedNeovim where each plugin's store path is wired
# into a lazy.nvim spec with `dir = <nix-store-path>`, so lazy.nvim never
# tries to clone anything from the internet.
{ pkgs, lib, ... }:
let
in
{
  # -- Neovim binary ------------------------------------------------------
  package = pkgs.neovim-unwrapped;
  viAlias = true;
  vimAlias = true;

  # -- LazyVim globals ----------------------------------------------------
  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };

  opts = {
    number         = true;
    relativenumber = true;
    expandtab      = true;
    shiftwidth     = 2;
    tabstop        = 2;
    termguicolors  = true;
    undofile       = true;
    signcolumn     = "yes";
    updatetime     = 200;
    timeoutlen     = 300;
    splitright     = true;
    splitbelow     = true;
  };

  # -- Plugins (all fetched by Nix, no runtime downloads) -----------------
  # nixvim's `plugins.lazy` module installs each plugin to the Nix store
  # and passes `dir = <path>` to lazy.nvim, which skips any download.
  plugins.lazy = {
    enable = true;

    # LazyVim itself is a Lua library - import it so its default specs load.
    # nixpkgs.vimPlugins tracks LazyVim releases and pins them in flake.lock.
    plugins = with pkgs.vimPlugins; [
      # -- LazyVim distribution --------------------------------------------
      LazyVim

      # -- Colorscheme (LazyVim default) -----------------------------------
      tokyonight-nvim

      # -- UI --------------------------------------------------------------
      bufferline-nvim
      lualine-nvim
      neo-tree-nvim
      noice-nvim
      nui-nvim
      nvim-notify
      nvim-web-devicons
      mini-nvim          # mini.icons, mini.pairs, mini.ai, ...

      # -- Editor ----------------------------------------------------------
      telescope-nvim
      telescope-fzf-native-nvim
      flash-nvim
      gitsigns-nvim
      which-key-nvim
      indent-blankline-nvim
      trouble-nvim
      todo-comments-nvim
      persistence-nvim
      plenary-nvim

      # -- Treesitter ------------------------------------------------------
      # nixvim compiles parsers at build time (no parser downloads at runtime)
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context

      # -- LSP -------------------------------------------------------------
      nvim-lspconfig
      mason-nvim            # Mason UI still works; servers must be pre-installed
      mason-lspconfig-nvim

      # -- Completion ------------------------------------------------------
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets

      # -- Formatting / Linting --------------------------------------------
      conform-nvim
      nvim-lint

      # -- Git -------------------------------------------------------------
      diffview-nvim
      neogit
      vim-fugitive      # :G command, time-tested complement to neogit
      lazygit-nvim      # floating lazygit TUI (<leader>gg)


      # -- Language: Python ------------------------------------------------
      nvim-dap-python   # DAP adapter - connects debugpy to nvim-dap

      # -- Language: C / C++ -----------------------------------------------
      clangd_extensions-nvim  # inlay hints, AST view, memory usage, ...
      cmake-tools-nvim        # :CMakeBuild/Run/Debug, target picker, CTest, overseer integration

      # -- Language: Go ----------------------------------------------------
      nvim-dap-go       # DAP adapter - connects delve to nvim-dap

      # -- DAP core (used by all language adapters above) ------------------
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text

      # -- Navigation ------------------------------------------------------
      harpoon2          # pin files, instant jump <leader>1-5
      fzf-lua           # faster fuzzy finder (complement/alternative to telescope)

      # -- Editing ---------------------------------------------------------
      nvim-surround     # ys/cs/ds to add, change, delete surrounding chars
      yanky-nvim        # yank ring: cycle paste history with <p> / <P>
      refactoring-nvim  # extract function/variable, inline var (Python/Go/C++)

      # -- Testing ---------------------------------------------------------
      neotest           # unified test runner UI
      neotest-python    # pytest / unittest adapter
      neotest-go        # go test adapter
      # neotest for C++ (gtest) is not yet in nixpkgs - fetch manually if needed

      # -- Tasks / terminal ------------------------------------------------
      overseer-nvim     # task runner: run build/test commands, watch output
      toggleterm-nvim   # persistent floating/split terminals, send-to-REPL

      # -- LSP enhancements ------------------------------------------------
      inc-rename-nvim   # LSP rename with live preview in the command line

      # -- UI --------------------------------------------------------------
      render-markdown-nvim  # render headers/tables/code blocks inline
    ];

    # Tell lazy.nvim this is an air-gapped environment:
    # - install.missing = false  -> don't try to fetch missing plugins
    # - checker.enabled = false  -> don't check for updates
    # LazyVim is loaded via its import spec below.
    settings = {
      install.missing        = false;
      checker.enabled        = false;
      change_detection.enabled = false;
      rocks.enabled          = false;   # no luarocks in air-gap
      performance.reset_packpath = true;
    };
  };

  # -- Treesitter: all parsers compiled by Nix (no runtime downloads) -----
  plugins.treesitter = {
    enable   = true;
    settings = {
      highlight.enable = true;
      indent.enable    = true;
    };
  };

  # -- LSP servers installed via Nix (not Mason network download) ---------
  plugins.lsp = {
    enable = true;
    servers = {
      # General
      lua_ls.enable   = true;
      nil_ls.enable   = true;
      bashls.enable   = true;
      jsonls.enable   = true;
      yamlls.enable   = true;

      # Python - pyright for type-checking; ruff_lsp for fast lint+format
      pyright.enable  = true;
      ruff.enable     = true;   # ruff's built-in LSP server (replaces deprecated ruff-lsp)

      # C / C++ - clangd from clang-tools in extraPackages below
      clangd.enable    = true;
      neocmake.enable  = true;   # CMakeLists.txt LSP

      # Go - gopls is the official language server
      gopls.enable    = true;
    };
  };

  # -- Extra runtime dependencies available on $PATH inside nvim ----------
  # These go into the wrapper's PATH - not Mason network downloads.
  extraPackages = with pkgs; [
    # -- General formatters / linters --------------------------------------
    stylua
    pkgs.nixfmt
    prettier
    shellcheck

    # -- Python ------------------------------------------------------------
    pyright                         # LSP binary (also referenced by plugins.lsp)
    ruff                            # fast linter + formatter (replaces black/isort/flake8)
    python3Packages.debugpy         # DAP backend for nvim-dap-python
    python3                         # needed by some plugins at startup

    # -- C / C++ -----------------------------------------------------------
    clang-tools                     # provides clangd + clang-format + clang-tidy
    lldb                            # DAP backend (lldb-vscode / codelldb adapter)
    cmake                           # build system, understood by clangd via compile_commands.json
    bear                            # generates compile_commands.json from make/cmake invocations
    neocmakelsp                     # LSP binary for CMakeLists.txt (used by extras.lang.cmake)

    # -- Go ----------------------------------------------------------------
    gopls                           # LSP binary
    delve                           # DAP backend for nvim-dap-go
    gofumpt                         # stricter gofmt (used by conform-nvim)
    gotools                         # provides goimports, godoc, etc.

    # -- Git ---------------------------------------------------------------
    git
    lazygit                         # TUI, opened by lazygit-nvim plugin

    # -- Perforce ----------------------------------------------------------
    # p4 (Helix Core CLI) is not in nixpkgs. Install it via your OS package
    # manager or org tooling and ensure it is on PATH when running nvim.
    # vim-perforce will find it automatically once p4 is available.

    # -- fzf-lua -----------------------------------------------------------
    fzf                             # fzf binary used by fzf-lua
    bat                             # syntax-highlighted file preview in fzf-lua

    # -- Tool deps ---------------------------------------------------------
    ripgrep
    fd
    gcc                             # treesitter parser compilation (fallback)
  ];

  # -- Bootstrap: wire LazyVim's default specs ----------------------------
  # This replaces the usual `init.lua` bootstrap that downloads lazy.nvim.
  # nixvim already handles lazy.nvim installation; we just need to tell
  # lazy.nvim to import LazyVim's default plugin specs.
  extraConfigLuaPre = ''
    -- LazyVim bootstrap (no download - nixvim pre-installed lazy.nvim)
    require("lazy").setup({
      spec = {
        -- -- LazyVim core -----------------------------------------------
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- -- Language extras --------------------------------------------
        -- Each import activates LazyVim's opinionated defaults for that
        -- language: LSP keymaps, conform formatters, nvim-lint sources,
        -- DAP launch configs, and treesitter parsers.
        -- All plugins they reference are pre-installed by Nix above.
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.clangd" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.cmake" },   -- pairs with C++

        -- -- Testing ----------------------------------------------------
        -- Activates neotest UI, keymaps (<leader>t*), and status line
        -- integration.  Language adapters above are wired in automatically.
        { import = "lazyvim.plugins.extras.test.core" },

        -- -- Git / UI extras --------------------------------------------
        { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

        -- -- Editor extras ----------------------------------------------
        -- inc-rename: replaces the default LSP rename handler with the
        -- live-preview version.  No extra import needed - configured below.

        -- -- User overrides ---------------------------------------------
        -- Loaded from XDG_CONFIG_HOME/nvim/lua/plugins/ - lua files only,
        -- no bootstrap code.  Use `dir =` for any local-only additions.
        { import = "plugins" },
      },
      install          = { missing = false },
      checker          = { enabled = false },
      rocks            = { enabled = false },
      change_detection = { enabled = false },
    })
  '';
}
