{ pkgs, ... }:
let
  lazySpec = pkgs.writeText "lazyvim-spec.lua" ''
    return {
      { "LazyVim/LazyVim", import = "lazyvim.plugins" },
      { import = "lazyvim.plugins.extras.lang.typescript" },
      { import = "lazyvim.plugins.extras.lang.json" },
      { import = "lazyvim.plugins.extras.lang.python" },
      { import = "lazyvim.plugins.extras.lang.rust" },
      { import = "lazyvim.plugins.extras.coding.copilot" },
      { import = "lazyvim.plugins.extras.editor.mini-files" },
      { import = "lazyvim.plugins.extras.util.project" },
      { import = "lazyvim.plugins.extras.ui.edgy" }
    }
  '';
in {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };

        options = {
          number = true;
          relativenumber = true;
          cursorline = true;
          signcolumn = "yes";
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
          termguicolors = true;
        };

        lazy = {
          enable = true;
          install = {
            colorscheme = [ "tokyonight" "catppuccin" "kanagawa" ];
            missing = true;
          };
          opts = {
            defaults = {
              lazy = false;
              version = false;
            };
            checker = {
              enabled = true;
              notify = false;
            };
            change_detection = {
              enabled = true;
              notify = false;
            };
            performance = {
              rtp = {
                disabled_plugins = [
                  "gzip"
                  "matchit"
                  "matchparen"
                  "netrwPlugin"
                  "tarPlugin"
                  "tohtml"
                  "tutor"
                  "zipPlugin"
                ];
              };
            };
            colorscheme = "tokyonight";
          };
          plugins = {
            spec = lazySpec;
          };
        };

        lsp = {
          enable = true;
          inlayHints = true;
          formatOnSave = true;
          servers = {
            lua-ls.enable = true;
            tsserver.enable = true;
            pyright.enable = true;
            rust-analyzer.enable = true;
          };
        };

        treesitter = {
          enable = true;
          ensureInstalled = [
            "bash"
            "css"
            "html"
            "javascript"
            "json"
            "lua"
            "markdown"
            "nix"
            "python"
            "rust"
            "tsx"
            "typescript"
            "yaml"
          ];
        };

        formatter = {
          enable = true;
          formatOnSave = "file";
        };

        diagnostic = {
          enable = true;
          virtualText = true;
          underline = true;
        };

        git = {
          enable = true;
          gitsigns = {
            enable = true;
            currentLineBlame = true;
          };
        };

        assistant.avante-nvim = {
          enable = true;
          setupOpts = {
            provider = "codex";
            providers = {
              gpt_5_codex = {
                __inherited_from = "openai";
                mode = "gpt-5-codex";
              };
            };
          };
        };
      };
    };
  };
}
