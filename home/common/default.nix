{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Shared user environment baseline: CLI tools, terminal
  # apps, and user-agnostic program settings. Personal
  # preferences (themes, mime apps, sops) live in
  # home/users/<name>/default.nix.

  home = {
    packages = with pkgs; [
      adwaita-qt6 # Qt6 Adwaita style
    ];

    # Aliases specifically for Eza
    shellAliases = {
      l = "eza";
      lt = "eza --tree --level=2";
      tree = "eza --tree";
      # ls = "eza"; # why should delete: eza is already aliased to ls by enableBashIntegration? Check docs.
    };
  };

  # Silence Home Manager news updates on rebuild
  news.display = "silent";

  programs = {
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
}
