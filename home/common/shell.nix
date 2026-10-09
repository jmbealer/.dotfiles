{
  config,
  lib,
  pkgs,
  ...
}: {
  # Shell configuration (Bash & Readline) — shared baseline
  # for the user's shell on every machine.

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
        source <(carapace _carapace bash | sed 's/read -r -d/builtin read -r -d')
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
        vdh = "vim /home/cipher/.dotfiles/home/users/cipher/default.nix";
        vdc = "vim /home/cipher/.dotfiles/hosts/serval/default.nix";
        vdp = "vim /home/cipher/.dotfiles/hosts/serval/packages.nix";
        vdn = "vim /home/cipher/.dotfiles/modules/home/editors/nvf.nix";
        vch = "vim /home/cipher/.config/hypr/hyprland.conf";

        # NixOS Management
        onr = "sudo nixos-rebuild switch --flake /home/cipher/.dotfiles/";
        nr = "nh os switch";
        # nu = "nh home switch";
        nu = "home-manager switch --flake /home/cipher/.dotfiles";
        enr = "fd . /home/cipher/.dotfiles/ | entr -c sudo nixos-rebuild switch --flake /home/cipher/.dotfiles/#serval"; # Watch and rebuild

        # Keyboard Shortcuts
        kb-red = "sudo sh -c 'for zone in left center right extra; do [ -f /sys/class/leds/system76::kbd_backlight/color_\\$zone ] && echo FF0000 > /sys/class/leds/system76::kbd_backlight/color_\\$zone; done && brightnessctl -d \"system76::kbd_backlight\" set 50%'";

        # Utilities
        cat = "bat"; # Use bat instead of cat
        # grep = "rg"; # why should delete: ripgrep is a different tool, aliasing might break scripts expecting grep behavior
      };
    };
  };
}
