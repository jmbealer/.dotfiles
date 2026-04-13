{
  config,
  pkgs,
  inputs,
  sops,
  ...
}: {
  # Imports: Modularize configuration by importing separate files
  imports = [
    ../../modules/home-manager/editors/nvf.nix
    ../../modules/home-manager/programs/rofi.nix
  ];

  home = {
    # Home Manager Metadata
    username = "cipher";
    homeDirectory = "/home/cipher";
    # stateVersion = "25.05"; # Check release notes before changing
    stateVersion = "26.05"; # Check release notes before changing

    # Aliases specifically for Eza
    shellAliases = {
      l = "eza";
      lt = "eza --tree --level=2";
      tree = "eza --tree";
      # ls = "eza"; # why should delete: eza is already aliased to ls by enableBashIntegration? Check docs.
    };

    packages = with pkgs; [
      adwaita-qt6 # Qt6 Adwaita style
    ];
  };

  # Silence Home Manager news updates on rebuild
  news.display = "silent";

  programs = {
    # Shell Configuration (Bash & Readline)
    readline = {
      enable = true;
      variables = {
        completion-ignore-case = true; # Case-insensitive completion
        completion-map-case = true; # Treat hyphens/underscores identically
        show-all-if-ambiguous = true; # Show all matches immediately
        mark-symlinked-directories = true; # Append / to symlinked dirs
      };
      bindings = {
        "\e[A" = "history-search-backward"; # Up arrow searches history
        "\e[B" = "history-search-forward"; # Down arrow searches history
        "\e[C" = "forward-char";
        "\e[D" = "backward-char";
        "Space" = "magic-space"; # Expand history expansion on space
      };
    };

    bash = {
      enable = true;
      historyControl = ["erasedups" "ignoreboth"]; # Clean history
      historyFileSize = 100000;
      historySize = 500000;
      historyIgnore = ["&" "[ ]*" "exit" "ls" "bg" "fg" "history" "clear"];
      shellOptions = [
        "autocd" # cd to dir just by typing name
        "checkwinsize" # Update window size after command
        "globstar" # Enable **
        "histappend" # Append to history file
        "cmdhist" # Save multi-line commands as one
        "dirspell" # Correct directory names
        "cdspell" # Correct minor cd typos
        "cdable_vars" # cd to variable if directory not found
      ];
      sessionVariables = {
        PROMPT_DIRTRIM = "2"; # Shorten path in prompt
        HISTTIMEFORMAT = "%F %T "; # Add timestamps to history
        CDPATH = "."; # CD search path
      };
      bashrcExtra = ''
        # pfetch # why should delete: Using fastfetch instead
        fastfetch

        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional

        # Prevent file overwrite on stdout redirection (use >| to force)
        set -o noclobber

        # Record each line as it gets issued
        PROMPT_COMMAND='history -a'

        # Vi mode configuration
        set -o vi
        ble-bind -m vi_nmap --cursor 2
        # bleopt color_scheme=default # why should delete: Using manual color settings below
        ble-color-setface auto_complete fg=238,underline
        ble-face -s syntax_error fg=242
        ble-import -d integration/fzf-completion
        ble-import -d integration/fzf-key-bindings

        # Carapace integration (patched for ble.sh)
        source <(carapace _carapace bash | sed 's/read -r -d/builtin read -r -d/')
      '';

      shellAliases = {
        # File Operations
        cp = "cp -riv"; # Recursive, interactive, verbose
        mv = "mv -iv"; # Interactive, verbose
        mkdir = "mkdir -vp"; # Verbose, create parents

        # Yazi / File Navigation
        tf = "yazi";
        ft = "yazi";
        tfd = "yazi /home/cipher/.dotfiles/";
        tfc = "yazi /home/cipher/.config/";
        ftd = "yazi /home/cipher/.dotfiles/";
        ftc = "yazi /home/cipher/.config/";
        ftg2 = "yazi /home/cipher/gdrive/";
        ftg = "yazi /run/media/cipher/Elements-5TB/gdrive/";
        ftk = "yazi /home/cipher/Documents/my-knowledge-base/";
        ck = "cd /home/cipher/Documents/my-knowledge-base/";
        cc = "cd /home/cipher/.config";
        cdd = "cd /home/cipher/.dotfiles";
        cg2 = "cd /home/cipher/gdrive";
        cg = "cd /run/media/cipher/Elements-5TB/gdrive/";

        # Editors
        vim = "nvim";
        v = "vim";
        e = "emacs";
        n = "nano";

        # Configuration Shortcuts
        vdh = "vim /home/cipher/.dotfiles/homes/cipher/default.nix";
        vdc = "vim /home/cipher/.dotfiles/hosts/void/default.nix";
        vdp = "vim /home/cipher/.dotfiles/hosts/void/packages.nix";
        vdn = "vim /home/cipher/.dotfiles/modules/home-manager/editors/nvf.nix";
        vch = "vim /home/cipher/.config/hypr/hyprland.conf";

        # NixOS Management
        onr = "sudo nixos-rebuild switch --flake /home/cipher/.dotfiles/";
        nr = "nh os switch";
        enr = "fd . /home/cipher/.dotfiles/ | entr -c sudo nixos-rebuild switch --flake /home/cipher/.dotfiles/#void"; # Watch and rebuild

        # Keyboard Shortcuts
        kb-red = "sudo sh -c 'for zone in left center right extra; do [ -f /sys/class/leds/system76::kbd_backlight/color_\\$zone ] && echo FF0000 > /sys/class/leds/system76::kbd_backlight/color_\\$zone; done && brightnessctl -d \"system76::kbd_backlight\" set 50%'";

        # Utilities
        cat = "bat"; # Use bat instead of cat
        # grep = "rg"; # why should delete: ripgrep is a different tool, aliasing might break scripts expecting grep behavior
      };
    };

    # Terminal File Manager (Yazi)
    yazi = {
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
        };
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

    # Fuzzy Finder (Ctrl+R replacement)
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    # Smarter 'cd'
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    # Per-directory environment variables
    # direnv = {
    #   enable = true;
    #   nix-direnv.enable = true;
    #   enableBashIntegration = true;
    # };

    # Fast 'command-not-found' replacement
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };

    # Multi-shell completion binary (powers modern CLI completions)
    carapace = {
      enable = true;
      enableBashIntegration = false;
    };

    # Shell Prompt (Starship)
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {};
    };

    # LS_COLORS Support
    dircolors = {
      enable = true;
      enableBashIntegration = true;
    };

    # Modern 'ls' replacement (Eza)
    eza = {
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

    # Terminal Emulator (Foot)
    foot = {
      enable = true;
      settings = {
        main = {
          # font = "IosevkaTerm NF:size=12"; # why should delete: Using default font
          # theme = "nvim-dark"; # why should delete: Using custom colors
        };
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

    # Web Browser (Floorp)
    floorp.enable = true;

    # Version Control (Git)
    git = {
      enable = true;
      settings = {
        user.name = "jmbealer";
        user.email = "jmbealer11@gmail.com";
        init.defaultBranch = "main";
      };
    };

    # Modern Diff Viewer (Delta)
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    # LS_COLORS Generator (Vivid)
    vivid.enable = true;
  };

  # Secrets Management (SOPS)
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/home/cipher/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      # msmtp-password = { }; # why should delete: Placeholder/Unused secret
    };
  };

  # Systemd Service for Google Drive Bidirectional Sync
  # systemd.user.services.gdrive-sync = {
  #   Unit = {
  #     Description = "Google Drive Bidirectional Sync";
  #     After = ["network-online.target"];
  #     Wants = ["network-online.target"];
  #   };
  #   Service = {
  #     # Loop to run bisync every 5 minutes
  #     ExecStart = "${pkgs.writeShellScript "gdrive-sync-loop" ''
  #       export PATH="${pkgs.rclone}/bin:$PATH"
  #       REMOTE="gdrive:"
  #       LOCAL="/run/media/cipher/Elements-5TB/gdrive"
  #
  #       while true; do
  #         echo "Syncing $LOCAL <-> $REMOTE..."
  #         # bisync handles bidirectional sync.
  #         # Note: Run 'rclone bisync gdrive: /run/media/cipher/Elements-5TB/gdrive --resync' manually once if this is the first run.
  #         # rclone bisync "$REMOTE" "$LOCAL" \
  #         rclone bisync "$LOCAL" "$REMOTE" \
  #           # --create-empty-src-dirs \
  #           --drive-skip-gdoc \
  #           --links \
  #           --drive-skip-shortcuts \
  #           --compare size,modtime \
  #           --slow-hash-sync-only \
  #           --resync-mode newer \
  #           --recover \
  #           --verbose || echo "Sync error (will retry)"
  #         # sleep 300
  #         sleep 60
  #       done
  #     ''}";
  #     Restart = "always";
  #     RestartSec = "60";
  #   };
  #   Install = {
  #     WantedBy = ["default.target"];
  #   };
  # };

  # XDG Configuration & Default Apps
  xdg = {
    enable = true;
    configFile."hypr".source = ../../modules/home-manager/configs/hypr;
    configFile."waybar".source = ../../modules/home-manager/configs/waybar;

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
        "inode/directory" = ["org.gnome.Nautilus.desktop"];
      };
    };
  };

  # Global Theming (Stylix)
  stylix.targets = {
    qt.enable = false; # Manually configured below
    gnome.enable = false; # Manually configured below
    floorp.profileNames = ["default-release"];
  };

  # GTK Theme Configuration
  gtk = {
    enable = true;
    theme = {
      name = pkgs.lib.mkForce "Flat-Remix-GTK-Blue-Darkest";
      package = pkgs.lib.mkForce pkgs.flat-remix-gtk;
    };
    iconTheme = {
      name = pkgs.lib.mkForce "Papirus-Dark";
      package = pkgs.lib.mkForce pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = pkgs.lib.mkForce "Material-Black-Cursors";
      package = pkgs.lib.mkForce pkgs.material-cursors;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # GNOME Interface Settings
  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Qt Theme Configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };
}
