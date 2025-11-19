{
  config,
  pkgs,
  inputs,
  sops,
  ...
}:
# { lazyvim, ... }: { config, pkgs, ... }:

{
   imports = [
  # # "${pkgs.lazyvim-nix}/homeManagerModules/default"
  # lazyvim.homeManagerModules.lazyvim
    ./nvf.nix
   ];

  # home.packages = with pkgs; [
  # inputs.Akari.packages.x86_64-linux.default
  # ];

  home.username = "0xjb";
  home.homeDirectory = "/home/0xjb";
  home.stateVersion = "25.05";

  stylix.targets = {
    neovim.plugin = "base16-nvim";
    floorp.profileNames = [ "default-release" ];
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
                  pfetch

      cat /run/secrets/msmtp-password
      export AVANTE_OPENAI_API_KEY=$(cat /run/secrets/msmtp-password)
                  echo $AVANTE_OPENAI_API_KEY

            ## GENERAL OPTIONS ##

            shopt -s autocd

            # Prevent file overwrite on stdout redirection
            # Use `>|` to force redirection to an existing file
            set -o noclobber

            # Update window size after every command
            shopt -s checkwinsize

            # Automatically trim long paths in the prompt (requires Bash 4.x)
            PROMPT_DIRTRIM=2

            # Enable history expansion with space
            # E.g. typing !!<space> will replace the !! with your last command
            bind Space:magic-space

            # Turn on recursive globbing (enables ** to recurse all directories)
            shopt -s globstar 2> /dev/null

            ## SMARTER TAB-COMPLETION (Readline bindings) ##

            # Perform file completion in a case insensitive fashion
            bind "set completion-ignore-case on"

            # Treat hyphens and underscores as equivalent
            bind "set completion-map-case on"

            # Display matches for ambiguous patterns at first tab press
            bind "set show-all-if-ambiguous on"

            # Immediately add a trailing slash when autocompleting symlinks to directories
            bind "set mark-symlinked-directories on"

            ## SANE HISTORY DEFAULTS ##

            # Append to the history file, don't overwrite it
            shopt -s histappend

            # Save multi-line commands as one command
            shopt -s cmdhist

            # Record each line as it gets issued
            PROMPT_COMMAND='history -a'

            # Huge history. Doesn't appear to slow things down, so why not?
            HISTSIZE=500000
            HISTFILESIZE=100000

            # Avoid duplicate entries
            HISTCONTROL="erasedups:ignoreboth"

            # Don't record some commands
            export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

            # Use standard ISO 8601 timestamp
            # %F equivalent to %Y-%m-%d
            # %T equivalent to %H:%M:%S (24-hours format)
            HISTTIMEFORMAT='%F %T '

            # Enable incremental history search with up/down arrows (also Readline goodness)
            # Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
            bind '"\e[A": history-search-backward'
            bind '"\e[B": history-search-forward'
            bind '"\e[C": forward-char'
            bind '"\e[D": backward-char'

            ## BETTER DIRECTORY NAVIGATION ##

            # Prepend cd to directory names automatically
            shopt -s autocd 2> /dev/null
            # Correct spelling errors during tab-completion
            shopt -s dirspell 2> /dev/null
            # Correct spelling errors in arguments supplied to cd
            shopt -s cdspell 2> /dev/null

            # This defines where cd looks for targets
            # Add the directories you want to have fast access to, separated by colon
            # Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
            CDPATH="."

            # This allows you to bookmark your favorite places across the file system
            # Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
            shopt -s cdable_vars

            # Examples:
            # export dotfiles="$HOME/dotfiles"
            # export projects="$HOME/projects"
            # export documents="$HOME/Documents"
            # export dropbox="$HOME/Dropbox"

                ble-color-setface auto_complete fg=238,underline
                ble-face -s syntax_error fg=242
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
      # tfd = "yazi /home/0xjb/nixos-dotfiles/";
      tfd = "yazi /home/0xjb/.dotfiles/";
      tfc = "yazi /home/0xjb/.config/";
      # ls = "eza --group-directories-first";
      # la = "ls -la";
      # editors
      vim = "nvim";
      v = "vim";
      vdh = "vim /home/0xjb/.dotfiles/home.nix";
      vdc = "vim /home/0xjb/.dotfiles/configuration.nix";
      e = "emacs";
      n = "nano";
      # nixos
      nr = "sudo nixos-rebuild switch --flake /home/0xjb/.dotfiles/";
      enr = "'ls' | entr sudo nixos-rebuild switch --flake /home/0xjb/.dotfiles/";

      cat = "bat";
      # grep = "rg";
    };
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      full-border = full-border;
      starship = starship;
    };
    settings = {
      mgr = {
        # ratio = [ 2 3 4 ];
        show-hidden = true;
        show-symlink = true;
        sort_dirs_first = true;
      };
      plugin = {
        prepend_previewers = [
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
    settings = { };
    # presets = [
    #   "nerd-font-symbols"
    # ];
  };
  programs.dircolors.enableBashIntegration = true;
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

  programs.foot = {
    enable = true;
    # enableBashIntegration = true;
    # theme = "aeroroot";
    settings = {
      main = {
        font = "IosevkaTerm NF:size=12";
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
    ls = "eza";
    l = "eza";
    lt = "eza --tree --level=2";
    tree = "eza --tree";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        # "text/html" = "zen-beta.desktop";
        # "x-scheme-handler/http" = "zen-beta.desktop";
        # "x-scheme-handler/https" = "zen-beta.desktop";
        # "x-scheme-handler/about" = "zen-beta.desktop";
        # "application/x-extension-htm" = "zen-beta.desktop";
        # "application/x-extension-html" = "zen-beta.desktop";
        # "application/x-extension-shtml" = "zen-beta.desktop";
        # "application/xhtml+xml" = "zen-beta.desktop";
        # "application/x-extension-xhtml" = "zen-beta.desktop";
        # "application/x-extension-xht" = "zen-beta.desktop";
      };
    };
    # Portal configuration moved to system-level (modules/core/flatpak.nix)
    # to avoid package collisions between stable and unstable
  };

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

  programs.dankMaterialShell = {
    enable = true;
    # Core features
    # enableSystemd = true; # Systemd service for auto-start
    systemd.enable = true; # Systemd service for auto-start
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableClipboard = true; # Clipboard history manager
    enableVPN = true; # VPN management widget
    enableBrightnessControl = true; # Backlight/brightness controls
    enableColorPicker = true; # Color picker tool
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableSystemSound = true; # System sound effects

    # default.settings = {
    #   theme = "dark";
    #   dynamicTheming = true;
    #   # Add any other settings here
    # };
    #
    # default.session = {
    #   # Session state defaults
    # };
  };

  programs.floorp = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "jmbealer";
      user.email = "jmbealer11@gmail.com";
      init.defaultBranch = "main";
    };
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # keyFile = "/var/lib/sops-nix/key.txt";
      keyFile = "/home/0xjb/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      # msmtp-password = { };
    };

  };

  # users.users."0xjb".hashedPasswordFile = config.sops.secrets.Zxjb-password.path;

  # stylix = {
  #   enable = true;
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
