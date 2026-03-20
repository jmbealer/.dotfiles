{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # System Core & Development
    gcc # GNU Compiler Collection
    unzip # Archive extraction tool
    wget # Network downloader
    git # Version control
    gh # GitHub CLI
    sops # Secret management
    nextdns # NextDNS CLI client
    usbutils # USB device utilities (lsusb)
    lm_sensors # Hardware monitoring (sensors)
    smartmontools # SSD/HDD health monitoring
    nvtopPackages.full # GPU monitoring tool
    bottom # Modern, Rust-based system monitor
    alejandra # Nix code formatter
    nil # Nix language server
    tree-sitter # Incremental parsing library
    lua # Lua programming language
    python3 # Python programming language
    nodejs # Node.js runtime
    man-pages # Linux development man pages
    man-pages-posix # POSIX development man pages

    # Shell & Terminal Utilities
    foot # Wayland terminal emulator
    kitty # GPU-accelerated terminal
    starship # Cross-shell prompt
    blesh # Bash line editor enhancement
    zoxide # Smarter cd command
    bat # cat clone with syntax highlighting
    eza # Modern replacement for ls
    delta # Syntax-highlighting pager for git/diff
    pfetch-rs # Fast system info tool
    fastfetch # Feature-rich system info tool
    fd # Simple, fast alternative to find
    ripgrep # Fast search tool (grep replacement)
    ripgrep-all # Ripgrep for pdf, docx, etc.
    fzf # Command-line fuzzy finder
    lscolors # LS_COLORS generator
    tealdeer # Fast tldr client
    dust # Disk usage analyzer (du replacement)
    dua # Disk usage analyzer (interactive)
    jaq # Fast, Rust-based JSON processor
    trashy # Fast, Rust-based trash utility
    manix # Fast CLI documentation searcher for Nix
    nix-search-cli # CLI for searching nixpkgs
    navi # Interactive cheatsheet tool (Rust)
    cht-sh # CLI client for cheat.sh
    nix-bash-completions # Bash completions for Nix
    entr # Run arbitrary commands when files change
    yt-dlp
    ffmpeg-full
    # tts
    speechd
    pied

    # Editors & Git Tools
    vim # Classic text editor
    lazygit # Simple terminal UI for git
    gitui # Fast terminal UI for git
    codex # AI-powered code completion
    ruff # Extremely fast Python linter
    statix # Lints and suggestions for Nix
    lua-language-server # Lua LSP
    github-copilot-cli # GitHub Copilot for the CLI

    # File Management & Media
    (yazi.override {_7zz = _7zz-rar;}) # Terminal file manager with RAR support
    yaziPlugins.starship # Starship integration for Yazi
    # czkawka # Duplicate file finder
    czkawka-full # Duplicate file finder
    rclone # Rsync for cloud storage
    ouch # Unified compression/decompression tool
    unrar # RAR archive extractor
    ffmpegthumbnailer # Video thumbnailer
    mediainfo # Technical info about media files
    imagemagick # Image manipulation suite
    poppler # PDF rendering library
    poppler-utils # PDF command-line tools
    mupdf # Lightweight PDF viewer
    fontpreview # Preview fonts in the terminal
    exiftool # Read/Write meta information in files
    glow # Markdown renderer for the terminal
    pandoc # Universal document converter
    gnome-epub-thumbnailer # EPUB thumbnailer

    # Desktop Environment & Hyprland
    system76-keyboard-configurator # Config tool for System76 keyboards
    qt5.qtwayland # Wayland support for Qt5
    qt6.qtwayland # Wayland support for Qt6
    xdg-utils # Basic desktop integration utilities
    libsecret # Library for accessing the secret service
    rofi # Window switcher and launcher
    waybar # Highly customizable Wayland bar
    dconf # Low-level configuration system
    wl-clipboard # Command-line copy/paste for Wayland
    cliphist # Clipboard history manager
    grim # Wayland screenshot tool
    slurp # Select a region in a Wayland compositor
    swaybg # Wallpaper tool for Wayland
    hyprpaper # Wallpaper utility for Hyprland
    hyprlock # Screen locker for Hyprland
    hypridle # Idle daemon for Hyprland
    hyprpicker # Color picker for Hyprland
    swww # Efficient animated wallpaper daemon
    swaynotificationcenter # Notification daemon for Wayland
    wlogout # Logout menu for Wayland
    wlsunset # Night light for Wayland
    polkit_gnome # PolicyKit authentication agent
    libnotify # Notification library
    networkmanagerapplet # NetworkManager tray icon
    brightnessctl # Backlight control
    playerctl # Media player controller
    nwg-displays # Monitor configuration for Hyprland
    nwg-drawer # Application drawer for Wayland
    nwg-look # GTK customization for Wayland
    hyprcursor # Cursor theme format for Hyprland
    bitwarden-desktop
    bitwarden-cli
    bitwarden-menu
    anki
    adguardhome
    klavaro

    # Web Browsers
    firefox # Standard Firefox
    ungoogled-chromium # Privacy-focused Chromium
    microsoft-edge # Edge browser
    floorp-bin # Customizable Firefox fork
    tridactyl-native # Vim-like browsing for Firefox

    # Productivity & GUI Apps
    obsidian # Markdown-based knowledge base
    remnote # Note-taking and flashcard app
    w3m # Text-based web browser
    zathura # Plugin-based document viewer
    mpv # Versatile media player
    pavucontrol # PulseAudio volume control
    qjackctl # JACK control UI
    blueman # Bluetooth manager
    redshift # Screen color temperature adjustment
    gemini-cli # CLI for Gemini models
    wildcard # Simple file search utility
    typespeed # Typing practice game
    keymapp # ZSA keyboard configuration tool
    wiki-tui # Wikipedia TUI
    rclone-ui
    rclone-browser

    # Fonts
    nerd-fonts.geist-mono # Geist Mono Nerd Font
    nerd-fonts.jetbrains-mono # JetBrains Mono Nerd Font
    inter # Variable font family

    # GNOME & GTK Integration
    gtk3 # GTK 3 toolkit
    gtk4 # GTK 4 toolkit
    libadwaita # GNOME design language library
    adwaita-icon-theme # Standard GNOME icons
    material-cursors # Material design cursor theme
    lyra-cursors # Lyra cursor theme
    adwaita-qt # Adwaita theme for Qt apps
    nautilus # GNOME file manager
    gnome-control-center # GNOME settings app
    gnome-system-monitor # GNOME system monitor
    gnome-disk-utility # GNOME disk management tool
    gnome-online-accounts # Online account integration
    wrapGAppsHook4 # Hook for wrapping GTK4 apps
    gsettings-desktop-schemas # Settings schemas
    glib # Core library for GNOME
    glib-networking # Network extensions for GLIB
    gnome-settings-daemon # GNOME settings manager
    gnome-keyring # Secret storage
    gvfs # Virtual filesystem for GNOME
    google-drive-ocamlfuse # FUSE filesystem for Google Drive

    # Commented out / Possible Deletions
    # nixfmt-rfc-style      # why should delete: Using alejandra instead
    # nixd                  # why should delete: Using nil as Nix LSP
    # zellij                # why should delete: Using Kitty/Hyprland for multiplexing
    # hyprqt6engine         # why should delete: Redundant with adwaita-qt
    # wmenu                 # why should delete: Using Rofi for menus

    # KDE / Qt Integration
    # why should delete: Large amount of KDE dependencies in a Hyprland/Gnome setup. Use Gnome/GTK alternatives where possible.
    # libsForQt5.signond
    # kdePackages.dolphin
    # kdePackages.kaccounts-providers
    # kdePackages.kaccounts-integration
    # kdePackages.signond
    # kdePackages.signon-kwallet-extension
    # kdePackages.systemsettings
    # kdePackages.kirigami
    # kdePackages.kirigami-addons
    # kdePackages.qtstyleplugin-kvantum
    # kdePackages.kio
    # kdePackages.kio-gdrive
    # kdePackages.kio-fuse
    # kdePackages.kio-extras
    # kdePackages.kalm
    # kdePackages.artikulate
    # kdePackages.ktouch
  ];
}
