{
  config,
  lib,
  pkgs,
  ...
}: {
  # Shell configuration (Bash & Readline) — shared baseline
  # for the user's shell on every machine.

  home.file.".blerc".text = ''
    # ble.sh settings (evaluated only when ble.sh attaches to an interactive shell)
    ble-bind -m vi_nmap --cursor 2
    ble-color-setface auto_complete fg=238,underline
    ble-face -s syntax_error fg=242
    ble-import -d integration/fzf-completion
    ble-import -d integration/fzf-key-bindings
  '';

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
        # Prevent file overwrite on stdout redirection (use >| to force)
        set -o noclobber
      '';

      initExtra = ''
        # Interactive shell startup banner
        fastfetch

        # Vi mode configuration
        set -o vi

        # Carapace completion integration (with ble.sh compatibility patch)
        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
        if command -v carapace &>/dev/null; then
          source <(carapace _carapace bash | sed 's/read -r -d/builtin read -r -d/')
        fi

        # Append history on each prompt without clobbering Starship
        PROMPT_COMMAND="history -a; ''${PROMPT_COMMAND:-}"

        # System76 keyboard backlight helper function
        kb-color() {
          local color="''${1:-FF0000}"
          local brightness="''${2:-50%}"
          sudo bash -c "
            for zone in left center right extra; do
              f=/sys/class/leds/system76::kbd_backlight/color_\$zone
              [ -f \"\$f\" ] && echo '$color' > \"\$f\"
            done
            brightnessctl -d 'system76::kbd_backlight' set '$brightness'
          "
        }
      '';

      shellAliases = let
        dotfiles = "${config.home.homeDirectory}/.dotfiles";
        homeDir = config.home.homeDirectory;
      in {
        # File Operations & Safety
        cp = "cp -riv"; # Recursive, interactive, verbose
        mv = "mv -iv"; # Interactive, verbose
        mkdir = "mkdir -vp"; # Verbose, create parents
        cat = "bat"; # Use bat instead of cat

        # Yazi / File Navigation
        tf = "yazi";
        ft = "yazi";
        tfd = "yazi ${dotfiles}/";
        tfc = "yazi ${homeDir}/.config/";
        ftd = "yazi ${dotfiles}/";
        ftc = "yazi ${homeDir}/.config/";
        ftg2 = "yazi ${homeDir}/gdrive/";
        ftg = "yazi /run/media/cipher/Elements-5TB/gdrive/";
        ftk = "yazi ${homeDir}/Documents/my-knowledge-base/";
        ck = "cd ${homeDir}/Documents/my-knowledge-base/";
        cc = "cd ${homeDir}/.config";
        cdd = "cd ${dotfiles}";
        cg2 = "cd ${homeDir}/gdrive";
        cg = "cd /run/media/cipher/Elements-5TB/gdrive/";

        # Editors
        vim = "nvim";
        v = "vim";
        e = "emacs";
        n = "nano";

        # Configuration Shortcuts
        vdf = "vim ${dotfiles}/flake.nix";
        vdh = "vim ${dotfiles}/home/users/cipher/default.nix";
        vdc = "vim ${dotfiles}/hosts/serval/default.nix";
        vdp = "vim ${dotfiles}/hosts/serval/packages.nix";
        vdn = "vim ${dotfiles}/modules/home/editors/nvf.nix";
        vds = "vim ${dotfiles}/home/common/shell.nix";
        vdk = "vim ${dotfiles}/modules/home/desktop/kitty.nix";
        vch = "vim ${homeDir}/.config/hypr/hyprland.lua";
        vcn = "vim ${homeDir}/.config/noctalia/config.toml";

        # NixOS System Management (nh & nix)
        nos = "nh os switch"; # Rebuild and switch system
        not = "nh os test"; # Test rebuild without boot entry
        nob = "nh os boot"; # Rebuild and set boot entry without switching
        nosd = "nh os switch --dry"; # Dry-run system build
        nhs = "nh home switch"; # Rebuild and switch Home Manager
        nhsd = "nh home switch --dry"; # Dry-run Home Manager build
        nr = "nh os switch"; # Muscle-memory fallback
        nu = "nh home switch"; # Muscle-memory fallback
        onr = "sudo nixos-rebuild switch --flake ${dotfiles}#serval"; # Low-level fallback
        enr = "fd . ${dotfiles}/ | entr -c sudo nixos-rebuild switch --flake ${dotfiles}#serval"; # Watch and rebuild

        # Nix Updates
        nfu = "nix flake update --flake ${dotfiles}"; # Update all flake inputs
        nuo = "nh os switch --update"; # Update inputs & switch system
        nhu = "nh home switch --update"; # Update inputs & switch home-manager

        # Nix Search & Documentation
        ns = "nh search"; # Fast local package search
        nsp = "nix search nixpkgs"; # Search nixpkgs
        nso = "manix"; # Search options & documentation

        # Ephemeral Shells & Runs (Try without installing)
        nsh = "nix shell nixpkgs#"; # e.g. nsh ripgrep jq
        nrn = "nix run nixpkgs#"; # e.g. nrn cowsay
        nb = "nix build";

        # Maintenance & Garbage Collection
        ncg = "nh clean all"; # Clean old system & user generations
        ncgd = "nh clean all --dry"; # Dry-run clean
        ngen = "nixos-rebuild list-generations"; # List system generations
        nhgen = "home-manager generations"; # List user generations

        # Hardware & Keyboard Backlight
        kb-red = "kb-color FF0000 50%";
        kb-blue = "kb-color 0000FF 50%";
        kb-off = "brightnessctl -d 'system76::kbd_backlight' set 0%";
      };
    };
  };
}
