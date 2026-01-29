{
  config,
  pkgs,
  inputs,
  sops,
  ...
}: {
  # ============================================================================
  # Imports
  # ============================================================================
  imports = [
    # # "${pkgs.lazyvim-nix}/homeManagerModules/default"
    # lazyvim.homeManagerModules.lazyvim
    ../../modules/home-manager/editors/nvf.nix
    ../../modules/home-manager/programs/rofi.nix
  ];

  # ============================================================================
  # Home Information
  # ============================================================================
  home.username = "0xjb";
  home.homeDirectory = "/home/0xjb";
  home.stateVersion = "25.05";

  # home.packages = with pkgs; [
  # inputs.Akari.packages.x86_64-linux.default
  # ];

  # ============================================================================
  # Shell (Bash)
  # ============================================================================
  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = true;
      completion-map-case = true;
      show-all-if-ambiguous = true;
      mark-symlinked-directories = true;
    };
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
      "\\e[C" = "forward-char";
      "\\e[D" = "backward-char";
      "Space" = "magic-space";
    };
  };

  programs.bash = {
    enable = true;
    historyControl = ["erasedups" "ignoreboth"];
    historyFileSize = 100000;
    historySize = 500000;
    historyIgnore = ["&" "[ ]*" "exit" "ls" "bg" "fg" "history" "clear"];
    shellOptions = [
      "autocd"
      "checkwinsize"
      "globstar"
      "histappend"
      "cmdhist"
      "dirspell"
      "cdspell"
      "cdable_vars"
    ];
    sessionVariables = {
      PROMPT_DIRTRIM = "2";
      HISTTIMEFORMAT = "%F %T ";
      CDPATH = ".";
    };
    bashrcExtra = ''
      	pfetch
       # cat /run/secrets/msmtp-password
       # export AVANTE_OPENAI_API_KEY=$(cat /run/secrets/msmtp-password)
       # echo $AVANTE_OPENAI_API_KEY

       # Prevent file overwrite on stdout redirection
       # Use `>|` to force redirection to an existing file
       set -o noclobber

       # Record each line as it gets issued
       PROMPT_COMMAND='history -a'

      set -o vi
      ble-bind -m vi_nmap --cursor 2
      # bleopt color_scheme=default
       ble-color-setface auto_complete fg=238,underline
       ble-face -s syntax_error fg=242
       ble-import -d integration/fzf-completion
       ble-import -d integration/fzf-key-bindings
    '';

    # profileExtra = ''
    #   # Auto-start MangoWC only on TTY1
    #   if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    #     exec ~/.config/mangowc/autostart.sh
    #   fi
    # '';

    shellAliases = {
      # file access
      cp = "cp -riv";
      mv = "mv -iv";
      mkdir = "mkdir -vp";
      tf = "yazi";
      ft = "yazi";
      # tfd = "yazi /home/0xjb/nixos-dotfiles/";
      tfd = "yazi /home/0xjb/.dotfiles/";
      tfc = "yazi /home/0xjb/.config/";
      ftd = "yazi /home/0xjb/.dotfiles/";
      ftc = "yazi /home/0xjb/.config/";
      ftg = "yazi /home/0xjb/gdrive/";
      ftk = "yazi /home/0xjb/Documents/my-knowledge-base/";
      ck = "cd /home/0xjb/Documents/my-knowledge-base/";
      # ls = "eza --group-directories-first";
      # la = "ls -la";
      # editors
      vim = "nvim";
      v = "vim";
      # vdh = "vim /home/0xjb/.dotfiles/home.nix";
      vdh = "vim /home/0xjb/.dotfiles/homes/0xjb/default.nix";
      vdc = "vim /home/0xjb/.dotfiles/hosts/myhost/default.nix";
      vdp = "vim /home/0xjb/.dotfiles/hosts/myhost/packages.nix";
      vdn = "vim /home/0xjb/.dotfiles/modules/home-manager/editors/nvf.nix";
      vch = "vim /home/0xjb/.config/hypr/hyprland.conf";
      e = "emacs";
      n = "nano";
      # nixos
      nr = "sudo nixos-rebuild switch --flake /home/0xjb/.dotfiles/";
      enr = "fd . /home/0xjb/.dotfiles/ | entr -c sudo nixos-rebuild switch --flake /home/0xjb/.dotfiles/#myhost";

      cat = "bat";
      # grep = "rg";
    };
  };

  # ============================================================================
  # CLI Tools & Utilities
  # ============================================================================
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      full-border = full-border;
      starship = starship;
      glow = glow;
      ouch = ouch;
      mediainfo = mediainfo;
      piper = piper;
    };
    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';
    settings = {
      mgr = {
        # ratio = [ 2 3 4 ];
        show_hidden = true;
        show_symlink = true;
        sort_dirs_first = true;
      };
      opener = {
        view = [
          {
            run = ''kitty +kitten icat "$@"'';
            block = true;
            desc = "View Image";
          }
        ];
        # zathura = [
        #   {
        #     run = ''zathura "$@"'';
        #     detach = true;
        #     desc = "Zathura";
        #   }
        # ];
        # edit = [
        #   {
        #     run = ''nvim "$@"'';
        #     block = true;
        #     desc = "Edit";
        #   }
        # ];
        # open = [
        #   {
        #     run = ''xdg-open "$@"'';
        #     desc = "Open";
        #     detach = true;
        #   }
        # ];
      };
      # open = {
      #   rules = [
      #     { name = "*.pdf"; use = "zathura"; }
      #     { name = "*.epub"; use = "zathura"; }
      #     { mime = "text/*"; use = "edit"; }
      #     { name = "*"; use = "open"; }
      #   ];
      # };
      plugin = {
        prepend_previewers = [
          {
            name = "*.md";
            run = "glow";
          }
          {
            name = "*.epub";
            run = "mutool draw -F png -o - \"$1\" 1 | kitty +kitten icat";
          }
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "audio/*";
            run = "mediainfo";
          }
          {
            mime = "video/*";
            run = "mediainfo";
          }
          {
            name = "*/";
            run = ''piper -- eza -TL=2 --color=always --icons=always --group-directories-first --no-quotes -a "$1"'';
          }
        ];
      };
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {};
    # presets = [
    #   "nerd-font-symbols"
    # ];
  };

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableBashIntegration = true;
    git = true;

    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--header"
      "--git-ignore"
      "--icons=always"
      "--classify"
      "--hyperlink"
      "--all"
      "--long"
    ];
  };

  home.shellAliases = {
    # ls = "eza";
    l = "eza";
    lt = "eza --tree --level=2";
    tree = "eza --tree";
  };

  # ============================================================================
  # GUI Applications & Services
  # ============================================================================
  programs.foot = {
    enable = true;
    # enableBashIntegration = true;
    # theme = "aeroroot";
    settings = {
      main = {
        # font = "IosevkaTerm NF:size=12";
        # theme = "nvim-dark";
      };

      # cursor = {
      # color = "ffffff 7030af";
      # };

      colors = {
        cursor = "ffffff 7030af";
        foreground = "ffffff";
        background = "000000";
        selection-foreground = "ffffff";
        selection-background = "7030af";
        urls = "c6daff";

        regular0 = "000000";
        regular1 = "ff5f59";
        regular2 = "44bc44";
        regular3 = "d0bc00";
        regular4 = "2fafff";
        regular5 = "feacd0";
        regular6 = "00d3d0";
        regular7 = "ffffff";

        bright0 = "1e1e1e";
        bright1 = "ff5f5f";
        bright2 = "44df44";
        bright3 = "efef00";
        bright4 = "338fff";
        bright5 = "ff66ff";
        bright6 = "00eff0";
        bright7 = "989898";

        "16" = "fec43f";
        "17" = "ff9580";
      };
    };
  };

  programs.floorp = {
    enable = true;
  };

  # ============================================================================
  # Version Control
  # ============================================================================
  programs.git = {
    enable = true;
    settings = {
      user.name = "jmbealer";
      user.email = "jmbealer11@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # ============================================================================
  # Secrets Management (SOPS)
  # ============================================================================
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      # keyFile = "/var/lib/sops-nix/key.txt";
      keyFile = "/home/0xjb/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      # msmtp-password = { };
    };
  };

  # ============================================================================
  # XDG & Theming
  # ============================================================================
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Web
        "text/html" = ["floorp.desktop"];
        "x-scheme-handler/http" = ["floorp.desktop"];
        "x-scheme-handler/https" = ["floorp.desktop"];
        "x-scheme-handler/about" = ["floorp.desktop"];
        "x-scheme-handler/unknown" = ["floorp.desktop"];

        # Documents
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "application/epub+zip" = ["org.pwmt.zathura.desktop"];

        # Media
        "video/*" = ["mpv.desktop"];
        "audio/*" = ["mpv.desktop"];

        # Images
        "image/*" = ["org.gnome.Loupe.desktop"];

        # Text
        "text/plain" = ["nvim.desktop" "vim.desktop"];

        # Directories
        # "inode/directory" = ["yazi.desktop"];
        "inode/directory" = ["org.gnome.Nautilus.desktop"];
      };
    };
  };

  programs.vivid = {
    enable = true;
    # themes = "solarized-dark";
    # theme = "tokyonight-night";
  };

  stylix.targets = {
    qt.platform = "qtct";
    gnome.enable = false;
    # kitty.enable = true;

    # neovim.plugin = "base16-nvim";
    floorp.profileNames = ["default-release"];

    # vivid.enable = true;
    # vidid.colors.enable = true;
  };

  # ============================================================================
  # Commented-out Configurations (Archived)
  # ============================================================================

  # wayland.windowManager.hyprland.plugins = [
  # pkgs.hyprlandPlugins.
  # ];

  # programs.neovim = {
  # 	enable = true;
  #    plugins = [
  #      pkgs.vimPlugins.LazyVim
  #      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  #    ];
  #    # extraLuaConfig = ''
  #    # ''
  # };

  # programs.neovim = {
  #   enable = true;
  # defaultEditor = true;
  # viAlias = true;
  # vimAlias = true;
  #   extraPackages = with pkgs; [
  #     nodejs
  #     python3
  #     tree-sitter
  #   ];
  #   plugins = [
  #     pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  #   ];
  # };

  # programs.vim.defaultEditor = true;
  #
  # programs.lazyvim = {
  #   enable = true;
  #   # defaultEditor = true;
  #   # configFiles = "/home/0xjb/.config/nvim";
  #
  #   extras = {
  #     lang.nix = {
  #       enable = true;
  #       installDependencies = true;
  #     };
  #     lang.python = {
  #       enable = true;
  #       installDependencies = true; # Install ruff
  #       # installRuntimeDependencies = true; # Install python3
  #     };
  #     lang.go = {
  #       enable = true;
  #       installDependencies = true; # Install gopls, gofumpt, etc.
  #       installRuntimeDependencies = true; # Install go compiler
  #     };
  #     dap.core = {
  #       enable = true;
  #       installDependencies = true;
  #     };
  #     util.dot = {
  #       enable = true;
  #       installDependencies = true;
  #     };
  #     ai.avante = {
  #       enable = true;
  #       installDependencies = true;
  #       # installRuntimeDependencies = true;
  #     };
  #     ai.copilot = {
  #       enable = true;
  #       installDependencies = true;
  #       installRuntimeDependencies = true;
  #     };
  #   };
  #   # Additional packages (optional)
  #   extraPackages = with pkgs; [
  #     tree-sitter
  #     nixd # Nix LSP
  #     alejandra # Nix formatter
  #     ripgrep
  #     fd
  #     lazygit
  #     fzf
  #     curl
  #     # pip
  #     # ruff
  #   ];
  #
  #   # Only needed for languages not covered by LazyVim
  #   # treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
  #   # treesitterParsers = with pkgs.tree-sitter-grammars; [
  #   # # tree-sitter-wgsl      # WebGPU Shading Language
  #   #   tree-sitter-templ     # Go templ files
  #   # ];
  #
  #   config = {
  #     options = ''
  #       vim.opt.relativenumber = false
  #       vim.opt.cursorcolumn = true
  #       vim.opt.scrolloff = 7
  #     '';
  #     keymaps = ''
  #       vim.keymap.set("n", "<leader>w", "<cmd>w<cr", { desc = "Save"})
  #     '';
  #   };
  #   plugins = {
  #     # "catppuccin/nvim",
  #     # flavour = "mocha"
  #     colorscheme = ''
  #         return {
  #         { "miikanissi/modus-themes.nvim" },
  #         { "RRethy/base16-nvim" },
  #           {
  #             "LazyVim/LazyVim",
  #             opts = {
  #               colorscheme = "base16-3024",
  #             },
  #           }
  #       }
  #     '';
  #     avante = ''
  #       return {
  #         "yetone/avante.nvim",
  #         opts = {
  #           provider = "openai",
  #         }
  #       }
  #     '';
  #   };
  # };

  # programs.nvf = {
  # enable = true;

  # settings = {
  # vim.viAlias = true;
  # vim.vimAlias = true;
  # vim.lsp = {
  # enable = true;
  # };
  # vim.assistant.avante-nvim.enable = true;
  # vim.assistant.avante-nvim.setupOpts.prodider = "codex";
  # vim.assistant.avante-nvim.setupOpts.prodiders = {
  # gpt_5_codex = {
  # __inherited_from = "openai";
  # mode = "gpt-5-codex";
  # };
  # };
  # };
  # };

  # programs.nixvim = {
  #   enable = true;
  #   imports = [ ./nixvim.nix ];
  # };

  # gtk = {
  #   # iconTheme = {
  #   #   name = "Tela-purple-dark";
  #   #   package = pkgs.tela-icon-theme;
  #   # };
  #   gtk3.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  # };

  # programs.dankMaterialShell = {
  #   enable = true;
  #   # Core features
  #   # enableSystemd = true; # Systemd service for auto-start
  #   systemd.enable = true; # Systemd service for auto-start
  #   enableSystemMonitoring = true; # System monitoring widgets (dgop)
  #   enableClipboard = true; # Clipboard history manager
  #   enableVPN = true; # VPN management widget
  #   enableBrightnessControl = true; # Backlight/brightness controls
  #   enableColorPicker = true; # Color picker tool
  #   enableDynamicTheming = true; # Wallpaper-based theming (matugen)
  #   enableAudioWavelength = true; # Audio visualizer (cava)
  #   enableCalendarEvents = true; # Calendar integration (khal)
  #   enableSystemSound = true; # System sound effects
  #
  #   # default.settings = {
  #   #   theme = "dark";
  #   #   dynamicTheming = true;
  #   #   # Add any other settings here
  #   # };
  #   #
  #   # default.session = {
  #   #   # Session state defaults
  #   # };
  # };

  # home.file.".config/nvim".source = ./config/nvim;
  #
  #
  # things to look at later
  # sshrc
  # bashmount
  # shellcheck
  # shfmt
  # lscolors
}
