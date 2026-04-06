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

      # -- Colorschemes ----------------------------------------------------
      tokyonight-nvim
      vscode-nvim    # VS Code dark/light theme
      onedark-nvim   # Atom One Dark theme

      # -- Core LazyVim dependency (required at startup) -------------------
      snacks-nvim       # LazyVim uses Snacks for notifications, picker, dashboard, ...

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
      # blink.cmp is LazyVim's default completion engine since v14.
      # nvim-cmp and its sources are removed; blink.cmp has built-in LSP,
      # buffer, and path sources and its own luasnip integration.
      blink-cmp
      luasnip
      friendly-snippets

      # -- Formatting / Linting --------------------------------------------
      conform-nvim
      nvim-lint

      # -- Comments --------------------------------------------------------
      ts-comments-nvim    # LazyVim default: better comment strings per language

      # -- LazyVim core defaults (flagged Not Installed) -------------------
      catppuccin-nvim     # optional colorscheme referenced by LazyVim extras
      grug-far-nvim       # project-wide search & replace (replaced spectre)
      lazydev-nvim        # Lua development setup (replaced neodev.nvim)
      nvim-ts-autotag     # auto-close/rename HTML and JSX tags
      nvim-nio            # async library required by neotest

      # -- Python extra ----------------------------------------------------
      venv-selector-nvim  # Python venv picker (<leader>cv)

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
      neotest-golang    # go test adapter (LazyVim Go extra uses this, not neotest-go)
      # neotest for C++ (gtest) is not yet in nixpkgs - fetch manually if needed

      # -- Tasks / terminal ------------------------------------------------
      overseer-nvim     # task runner: run build/test commands, watch output
      toggleterm-nvim   # persistent floating/split terminals, send-to-REPL

      # -- LSP enhancements ------------------------------------------------
      inc-rename-nvim   # LSP rename with live preview in the command line

      # -- UI --------------------------------------------------------------
      render-markdown-nvim  # render headers/tables/code blocks inline
    ];

    settings = {
      # Air-gap settings: disable all network activity
      install.missing          = false;
      checker.enabled          = false;
      change_detection.enabled = false;
      rocks.enabled            = false;

      performance.reset_packpath = true;

      # Specs passed directly to nixvim's lazy setup call - no second
      # require("lazy").setup() needed, which avoids the "resourcing" warning.
      spec = [
        { "__unkeyed-1" = "LazyVim/LazyVim"; import = "lazyvim.plugins"; }

        # Language extras - each activates LSP keymaps, formatters,
        # DAP launch configs and treesitter parsers for that language.
        { import = "lazyvim.plugins.extras.lang.python"; }
        { import = "lazyvim.plugins.extras.lang.clangd"; }
        { import = "lazyvim.plugins.extras.lang.go"; }
        { import = "lazyvim.plugins.extras.lang.cmake"; }

        # Testing - neotest UI and keymaps (<leader>t*)
        { import = "lazyvim.plugins.extras.test.core"; }

        # UI extras
        { import = "lazyvim.plugins.extras.util.mini-hipatterns"; }

        # LazyVim references each mini module as a separate plugin identifier
        # (echasnovski/mini.pairs, mini.ai, etc.) but they all live inside
        # the single mini-nvim store path.  These entries tell lazy.nvim where
        # to find each one without downloading anything.
        { "__unkeyed-1" = "nvim-mini/mini.pairs";      dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.ai";          dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.icons";       dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.bufremove";   dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.hipatterns";  dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.indentscope"; dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.surround";    dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.statusline";  dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.tabline";     dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.comment";     dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.move";        dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.notify";      dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.pick";        dir = "${pkgs.vimPlugins.mini-nvim}"; }
        { "__unkeyed-1" = "nvim-mini/mini.trailspace";  dir = "${pkgs.vimPlugins.mini-nvim}"; }

        { "__unkeyed-1" = "folke/ts-comments.nvim"; dir = "${pkgs.vimPlugins.ts-comments-nvim}"; }

        # blink.cmp - LazyVim's default completion engine since v14
        { "__unkeyed-1" = "saghen/blink.cmp";              dir = "${pkgs.vimPlugins.blink-cmp}"; }
        { "__unkeyed-1" = "catppuccin/nvim";               dir = "${pkgs.vimPlugins.catppuccin-nvim}"; }
        { "__unkeyed-1" = "MagicDuck/grug-far.nvim";       dir = "${pkgs.vimPlugins.grug-far-nvim}"; }
        { "__unkeyed-1" = "folke/lazydev.nvim";            dir = "${pkgs.vimPlugins.lazydev-nvim}"; }
        { "__unkeyed-1" = "windwp/nvim-ts-autotag";        dir = "${pkgs.vimPlugins.nvim-ts-autotag}"; }
        { "__unkeyed-1" = "nvim-neotest/nvim-nio";         dir = "${pkgs.vimPlugins.nvim-nio}"; }
        { "__unkeyed-1" = "linux-cultist/venv-selector.nvim"; dir = "${pkgs.vimPlugins.venv-selector-nvim}"; }
        { "__unkeyed-1" = "fredrikaverpil/neotest-golang"; dir = "${pkgs.vimPlugins.neotest-golang}"; }

        # nvim-dap's Lua module is require("dap"), not require("nvim-dap").
        # lazy's auto-config tries require("nvim-dap").setup() which is nil.
        # Provide an explicit no-op so it wins over any auto-generated entry.
        { "__unkeyed-1" = "mfussenegger/nvim-dap"; config = { __raw = "function() end"; }; }


        # User overrides from XDG_CONFIG_HOME/nvim/lua/plugins/
        { import = "plugins"; }
      ];
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

}
