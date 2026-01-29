{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
in {
  programs.nvf = {
    enable = true;

    settings.vim = {
      # luaConfigRC.base16-nvim = "vim.cmd('colorscheme base16-3024')";
      # extraPlugins = {
      # base16-nvim = {
      # package = pkgs.vimPlugins.base16-nvim;
      # setup = "require('base16-nvim').setup {}";
      # };
      # };

      # extraPlugins = {
      #\t\t\tnvim-dap-virtual-text = {
      #\t\t\tpackage = pkgs.vimPlugins.nvim-dap-virtual-text;
      #\t\t\tafter = [ "nvim-dap" ];
      #\t\t\tsetup = ''
      #\t\t\t\t\t\t\t\trequire("nvim-dap-virtual-text").setup({
      #\t\t\t\t\t\t\t\tonly_first_definiton = false,
      #\t\t\t\t\t\t\t\tall_references = true,
      #\t\t\t\t\t\t\t})
      #\t\t\t\t\t\t\t''
      #\t\t\t};
      #\t\t};

      extraLuaFiles = [
        ./test.lua
        # ./nvim/test.lua
        # "$HOME/.dotfiles/test.lua"
      ];

      treesitter = {
        enable = true;
        # addDefaultGrammars = true;
        autotagHtml = true;
        fold = true;
        grammars = [
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        ];

        # context.enable = true;
        textobjects.enable = true;
        highlight.enable = true;
        indent.enable = true;
      };

      snippets.luasnip.enable = true;

      fzf-lua.enable = true;
      git.enable = true;

      highlight = {
        # CursorNormal = {
        #   bg = "#FF0000";
        #   # fg = "#FFFFFF";
        # };
        ModesDefaultCursor = {
          bg = "#FF033e";
          # fg = "#FFFFFF";
        };
        TermCursor = {
          bg = "#FF0000";
          fg = "#FFFFFF";
        };
      };

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
        # lspsaga.enable = false;
        # trouble.enable = true;
        lspSignature.enable = !true;
        otter-nvim.enable = true;
        # nvim-docs-view.enable = true;
        # harper-ls.enable = true;

        # servers.nixd = {
        #\t\t\t\tcapabilities = mkLuaInline "capabilities";
        #\t\t\t\ton_attach = mkLuaInline "default_on_attach";
        #\t\t\t\tcmd = ["${pkgs.nixd}/bin/nixd"];
        #\t\t\t\tsettings.nixd.formatting.command = ["${pkgs.alejandra}/bin/alejandra" "--quiet"];
        #\t\t};
      };

      enableLuaLoader = true;
      syntaxHighlighting = true;
      # theme.enable = true;
      # theme.enable = lib.mkForce false;
      # theme.name = lib.mkForce "minibase16";
      # theme.style = "darker";
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
        # cursorline = true;
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
        guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25";
        ignorecase = true;
        inccommand = "nosplit";
        jumpoptions = "view";
        # lasttatus = 3;
        linebreak = true;
        list = true;
        listchars = "tab:»·,trail:·,nbsp:␣";
        # listchars = ''
        # tab:»·,trail:·,nbsp:␣,"extends:...
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
        theme = lib.mkForce "auto";
        globalStatus = true;
        icons.enable = true;
      };

      assistant.avante-nvim = {
        enable = true;
        setupOpts.provider = "gemini-cli";
      };
      # assistant.codecompanion-nvim = {
      # enable = true;
      # };
      assistant.copilot = {
        enable = true;
        cmp.enable = true;
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
        nix.lsp.servers = ["nixd"];
        # rust.enable = true;
        # sql.enable = true;
        # ts.enable = true; # for typescript/javascript
        # bash.lsp.enable = true;
      };

      formatter.conform-nvim.enable = true;
      dashboard.alpha.enable = true;
      # autopairs.nvim-autopairs.enable = true;
      # comments.comment-nvim.enable = true;
      autocomplete = {
        enableSharedCmpSources = true;
        blink-cmp = {
          enable = true;
          sourcePlugins.ripgrep.enable = true;
          sourcePlugins.spell.enable = true;
          setupOpts.keymap.preset = "default";
          setupOpts.cmdline.keymap.preset = "default";
        };
      };

      ui = {
        # illuminate.enable = true;
        # nvim-highlight-colors.enable = true;
        borders.enable = true;
        smartcolumn.enable = true;
        colorful-menu-nvim.enable = true;
        colorizer.enable = true;
        modes-nvim = {
          enable = true; # nice!!
          setupOpts.line_opacity.visual = 0.5;
        };
        # noice.enable = true;
      };

      terminal.toggleterm = {
        # control T open terminal
        enable = true;
        lazygit.enable = true;
      };

      utility = {
        motion.precognition.enable = true;
        # leetcode-nvim.enable = true;
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
        # sources = {bash = "bashdb";};
        # sources = {
        #\t\t\tlldb-vscode = {
        #\t\t\t\tdapConfig = ''
        #\t\t\t\t\t\t\t\tdap.configurations.cpp = {
        #\t\t\t\t\t\t\t\t\t\t{
        #\t\t\t\t\t\t\t\t\t\tname = "Attach to process",
        #\t\t\t\t\t\t\t\t\t\ttype = "lldb",
        #\t\t\t\t\t\t\t\t\t\trequest = "attach",
        #\t\t\t\t\t\t\t\t\t\tpid = require('dap.utils').pick_process,
        #\t\t\t\t\t\t\t\t\t\targs = {},
        #\t\t\t\t\t\t\t\t\t}
        #\t\t\t\t\t\t\t\t}
        #\t\t\t\t\t\t\t''
        #\t\t\t\t\t\t\t};
        #\t\t};
      };

      keymaps = [
        {
          key = "<leader>q";
          mode = "";
          action = "";
          desc = "quit";
        }
        {
          key = "<leader>d";
          mode = "";
          action = "";
          desc = "dap";
        }
        {
          key = "<leader>g";
          mode = "";
          action = "";
          desc = "git";
        }
        {
          key = "<leader>l";
          mode = "";
          action = "";
          desc = "lsp";
        }
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
        {
          key = "<leader>f";
          mode = "";
          action = "";
          desc = "file";
        }
        {
          key = "<leader>ff";
          mode = "n";
          action = "<cmd>FzfLua files<cr>";
          desc = "Find Files";
          # silent = true;
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<cmd>FzfLua oldfiles<cr>";
          desc = "Find Recent Files";
          # silent = true;
        }
        {
          key = "<c-h>";
          mode = ["n"];
          action = "<c-w>h";
          desc = "Go to Left Window";
        }
        {
          key = "<c-j>";
          mode = ["n"];
          action = "<c-w>j";
          desc = "Go to Down Window";
        }
        {
          key = "<c-k>";
          mode = ["n"];
          action = "<c-w>k";
          desc = "Go to Up Window";
        }
        {
          key = "<c-l>";
          mode = ["n"];
          action = "<c-w>l";
          desc = "Go to Right Window";
        }
        {
          key = "<leader>bb";
          mode = ["n"];
          action = "<cmd>e #<cr>";
          desc = "Switch to Other Buffer";
        }
        {
          key = "<leader>bn";
          mode = ["n"];
          action = "<cmd>bdelete<cr>";
          desc = "Delete Buffer";
        }
        {
          key = "<s-h>";
          mode = ["n"];
          action = "<cmd>bprevious<cr>";
          desc = "Prev Buffer";
        }
        {
          key = "<s-l>";
          mode = ["n"];
          action = "<cmd>bnext<cr>";
          desc = "Next Buffer";
        }
        # window close
        {
          key = "<esc>";
          mode = ["t"];
          action = "<c-\\><c-n>";
          desc = "Escape Terminal Mode";
        }
        {
          key = "<leader>,";
          mode = ["n"];
          action = "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>";
          desc = "Switch Buffer";
        }
        # h k help keys
        # f s sav file
        # f S savas
        # f D delete this file
        # o t open terminal
        # o f open file explorer
        # w v window split vertically
        # w s window split horizontally
        # w q window quit
        # w o enlargen/fullscreen window
        # w u undo window size change
      ];

      visuals = {
        # rainbow-delimiters.enable = true;
      };

      mini = {
        basics.enable = true;
        pairs.enable = true;
        icons.enable = true;
        ai.enable = true;
        surround.enable = true;
        operators.enable = true;
        tabline.enable = true;
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
      #\t\t\tvim.opt.tabstop = 4
      #
      # ''
    };
  };
}
