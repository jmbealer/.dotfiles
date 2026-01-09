{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
in {
  programs.nvf = {
    enable = true;

    # settings.vim.luaConfigRC.base16-nvim = "vim.cmd('colorscheme base16-3024')";
    # settings.vim.extraPlugins = {
    # base16-nvim = {
    # package = pkgs.vimPlugins.base16-nvim;
    # setup = "require('base16-nvim').setup {}";
    # };
    # };

    # settings.vim.extraPlugins = {
    #		nvim-dap-virtual-text = {
    #			package = pkgs.vimPlugins.nvim-dap-virtual-text;
    #			after = [ "nvim-dap" ];
    #			setup = ''
    #				require("nvim-dap-virtual-text").setup({
    #					only_first_definiton = false,
    #					all_references = true,
    #				})
    #			'';
    #		};
    # };
    settings.vim.extraLuaFiles = [
      ./test.lua
      # ./nvim/test.lua
      # "$HOME/.dotfiles/test.lua"
    ];
    settings.vim.treesitter = {
      enable = true;
      # addDefaultGrammars = true;
      autotagHtml = true;
      fold = true;
      grammars = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];

      context.enable = true;
      textobjects.enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    settings.vim.snippets.luasnip.enable = true;

    # settings.vim.debugger.nvim-dap.sources = {bash = "bashdb";};
    # settings.vim.debugger.nvim-dap.sources = {
    #		lldb-vscode = {
    #			dapConfig = ''
    #				dap.configurations.cpp = {
    #					{
    #						name = "Attach to process",
    #						type = "lldb",
    #						request = "attach",
    #						pid = require('dap.utils').pick_process,
    #						args = {},
    #					},
    #				}
    #
    #			'';
    #		};
    # };

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        undoFile = {
          enable = true;
        };
        # luaConfigRC.custom = builtins.readFile ./init.lua;
        # extraPackages = [];
        # extraPlugins = {};
        # autosaving.enable = true;
        preventJunkFiles = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        spellcheck = {
          enable = true;
          programmingWordlist.enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          inlayHints.enable = true;

          lspconfig.enable = true;
          lspkind.enable = false;
          # lightbulb.enable = true;
          # lspsaga.enable = false;
          # trouble.enable = true;
          # lspSignature.enable = !true;
          # otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          # harper-ls.enable = true;
        };

        enableLuaLoader = true;
        syntaxHighlighting = true;
        # theme.enable = lib.mkForce false;
        # theme.name = lib.mkForce "gruvbox";
        # theme.style = "dark";
        # lsp.enable = true;
        # lsp.lspconfig.enable = true;
        diagnostics.enable = true;
        diagnostics.config.virtual_lines = true;
        diagnostics.nvim-lint.enable = true;

        globals = {
          mapleader = " ";
          # maplocalleader = ",";
          maplocalleader = "\\";
          autoformat = true;
          deprecation_warnings = false;
        };

        options = {
          autowrite = true;
          # breakindent = true;
          # clipboard = ''vim.env.SSH_CONNECTION and "" or "unnamedplus"'';
          completeopt = "menu,menuone,noselect";
          conceallevel = 2;
          confirm = true;
          cursorcolumn = true;
          cursorline = true;
          expandtab = false;
          # fillchars = ''
          # foldopen = "",
          # foldclose = "",
          # fold = " ",
          # foldsep = " ",
          # diff = "╱",
          # eob = " ",
          # '';
          foldlevel = 99;
          foldmethod = "indent";
          foldtext = "";
          # formatexpr = "";
          formatoptions = "jcroqlnt";
          grepformat = "%f:%l:%c:%m";
          grepprg = "rg --vimgrep";
          ignorecase = true;
          inccommand = "nosplit";
          jumpoptions = "view";
          # lasttatus = 3;
          linebreak = true;
          list = true;
          listchars = "tab:»·,trail:·,nbsp:␣";
          # listchars = ''
          # tab:»·,trail:·,nbsp:␣,"extends:..."
          # '';
          mouse = "a";
          number = true;
          pumblend = 10;
          pumheight = 10;
          relativenumber = true;
          ruler = false;
          scrolloff = 10;
          # sessionoptions =
          # shiftround = true;
          shiftwidth = 2;
          # shortmess
          showmode = false;
          # sidesscrolloff = 8;
          signcolumn = "yes";
          smartcase = true;
          # smartindent = true;
          smoothscroll = true;
          # diagnostics.nvim-lint.enable = true;
          # spelllang = { "en" };
          splitbelow = true;
          splitkeep = "screen";
          splitright = true;
          # statuscolumn
          tabstop = 2;
          termguicolors = true;
          # timeoutlen
          undofile = true;
          undolevels = 10000;
          updatetime = 200;
          virtualedit = "block";
          wildmode = "longest:full,full";
          winminwidth = 5;
          wrap = false;
        };

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          registers = "unnamedplus";
        };

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        statusline.lualine = {
          enable = true;
          # theme = "auto";
          globalStatus = true;
          icons.enable = true;
        };

        # lazy = {
        # enable = true;
        # };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          enableDAP = true;

          bash.enable = true;
          # bash.dap.enable = true;
          clang.enable = true;
          # clang.dap.debugger = "codelldb";
          # css.enable = true;
          # clang.dap.enable = true;
          go.enable = true;
          # html.enable = true;
          # json.enable = true;
          # lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          nix.lsp.server = "nixd";
          # rust.enable = true;
          # sql.enable = true;
          # ts.enable = true; # for typescript/javascript
          # bash.lsp.enable = true;
        };

        # lsp.servers.nixd = {
        #		capabilities = mkLuaInline "capabilities";
        #		on_attach = mkLuaInline "default_on_attach";
        #		cmd = ["${pkgs.nixd}/bin/nixd"];
        #		settings.nixd.formatting.command = ["${pkgs.alejandra}/bin/alejandra" "--quiet"];
        # };
        #
        formatter.conform-nvim.enable = true;
        dashboard.alpha.enable = true;
        # autopairs.nvim-autopairs.enable = true;
        # comments.comment-nvim.enable = true;
        autocomplete = {
          blink-cmp.enable = true;
          enableSharedCmpSources = true;
          blink-cmp.sourcePlugins.ripgrep.enable = true;
          blink-cmp.sourcePlugins.spell.enable = true;
        };

        ui = {
          borders.enable = true;
          # colorizer.enable = true;
          # illuminate.enable = true;
          # modes-nvim.enable = true;
          smartcolumn.enable = true;
          nvim-highlight-colors.enable = true;
        };

        terminal.toggleterm = {
          # control T open terminal
          enable = true;
          lazygit.enable = true;
        };

        utility = {
          motion.precognition.enable = true;
          leetcode-nvim.enable = true;
          # surround.enable = true;
          yazi-nvim = {
            enable = true;
            mappings.yaziToggle = "<c-n>";
            setupOpts.open_for_directories = true;
          };
        };

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        keymaps = [
          {
            key = "<leader>qq";
            mode = "n";
            action = "<cmd>qa<cr>";
            desc = "Quit All";
            # silent = true;
          }
          {
            key = "<leader>fn";
            mode = "n";
            action = "<cmd>enew<cr>";
            desc = "New File";
            # silent = true;
          }
          # {
          #   key = "<leader>s";
          #   mode = "n";
          #   action = "<cmd>update<cr><cmd>source<cr>";
          #   desc = "Source";
          #   # silent = true;
          # }
          {
            key = "<c-s>";
            mode = ["n" "x" "i" "s"];
            # action = ":w<cr>";
            action = "<cmd>w<cr><esc>";
            desc = "Save File";
            # silent = true;
          }
          {
            key = "j";
            mode = ["n" "x"];
            action = "v:count == 0 ? 'gj' : 'j'";
            desc = "Down";
            silent = true;
            expr = true;
          }
          {
            key = "k";
            mode = ["n" "x"];
            action = "v:count == 0 ? 'gk' : 'k'";
            desc = "Up";
            silent = true;
            expr = true;
          }
        ];

        mini = {
          basics.enable = true;
          pairs.enable = true;
          icons.enable = true;
          ai.enable = true;
          surround.enable = true;
          operators.enable = true;
        };
      };
    };
    # config.vim.lazy.plugins = {
    # aerial.nvim = {
    # package = aerial-nvim;

    # setupModule = "aerial";
    # setupOpts = {option_name = false;};

    # after = "print('aerial loaded')";
    # };
    # };
    # settings.vim.luaConfigPost = "${builtins.readFile ./test.lua}";
    # settings.vim.luaConfigPost = ''
    #		vim.opt.tabstop = 4
    #
    # '';
  };
}
