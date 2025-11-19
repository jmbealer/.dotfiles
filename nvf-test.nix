{ pkgs, lib, ... }: let
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

    settings.vim.treesitter ={
      enable = true;
      # addDefaultGrammars = true;
      autotagHtml = true;
      fold = true;
      grammars = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];

      # context.enable = false;
      textobjects.enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        enableLuaLoader = true;
        syntaxHighlighting = true;
        preventJunkFiles = true;
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
        };

        options = {
          autowrite = true;
          breakindent = true;
          # clipboard = ''vim.env.SSH_CONNECTION and "" or "unnamedplus"'';
          completeopt = "menu,menuone,noselect";
          conceallevel = 2;
          confirm = true;
          cursorcolumn = true;
          cursorline = true;
          expandtab = true;
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
          shiftround = true;
          shiftwidth = 2;
          # shortmess
          showmode = false;
          # sidesscrolloff = 8;
          signcolumn = "yes";
          smartcase = true;
          smartindent = true;
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
          };

        lsp.servers.nixd = {
          capabilities = mkLuaInline "capabilities";
          on_attach = mkLuaInline "default_on_attach";
          cmd = ["${pkgs.nixd}/bin/nixd"];
          settings.nixd.formatting.command = ["${pkgs.alejandra}/bin/alejandra" "--quiet"];
        };

formatter.conform-nvim.enable = true;
dashboard.alpha.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
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
          surround.enable = true;
          yazi-nvim = {
            enable = true;
            mappings.yaziToggle = "<c-n>";
            setupOpts.open_for_directories = true;
          };
        };

        debugger.nvim-dap = {
          enable = true;
          # ui.enable = true;
        };

        keymaps = [
          {
            key = "<leader>qq";
            mode = "n";
            silent = true;
            action = ":q<cr>";
            desc = "quiting";
          }
          {
            key = "<c-s>";
            mode = "n";
            silent = true;
            action = ":w<cr>";
          }
        ];


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
  };
}
