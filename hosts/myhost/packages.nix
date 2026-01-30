{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # --- System & Core ---
    gcc
    unzip
    wget
    git
    gh
    sops
    usbutils
    lm_sensors
    # nixfmt-rfc-style
    alejandra
    # nixd
    nil
    tree-sitter
    lua
    python3
    nodejs
    # (python3.withPackages (python-pkgs: with python-pkgs; [
    # pip
    # ]))

    # --- Shell & Terminal Utilities ---
    foot
    kitty
    starship
    blesh
    zoxide
    bat
    eza
    delta
    pfetch-rs
    fd # or fdfind
    ripgrep
    ripgrep-all
    fzf
    lscolors
    tealdeer
    dust
    dua
    # xh
    # hyperfine
    # fselect
    # tokei
    nix-bash-completions

    # --- Editors ---
    vim # neovim
    lazygit
    gitui
    # bash-debug-adapter
    # bashdb
    codex
    ruff
    statix
    lua-language-server
    github-copilot-cli
    # zellij

    # --- File Management & Archives ---
    yazi
    yaziPlugins.starship
    (yazi.override {
      _7zz = _7zz-rar;
    })
    czkawka
    rclone
    ouch # atool
    unrar
    ffmpegthumbnailer
    mediainfo
    imagemagick
    poppler
    poppler-utils
    mupdf
    fontpreview
    exiftool
    glow
    pandoc
    gnome-epub-thumbnailer

    # --- Desktop & GUI Apps ---
    rofi
    waybar
    dconf
    wl-clipboard
    cliphist
    grim
    slurp
    swaybg
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    swww
    swaynotificationcenter
    wlogout
    polkit_gnome
    libnotify
    networkmanagerapplet
    brightnessctl
    playerctl
    nwg-displays
    nwg-drawer
    nwg-look
    hyprcursor
    wlsunset
    # hyprqt6engine
    # wmenu

    firefox
    ungoogled-chromium
    microsoft-edge
    floorp-bin

    obsidian
    remnote
    w3m
    zathura

    mpv
    pavucontrol
    qjackctl
    blueman
    redshift

    gemini-cli
    wildcard
    typespeed
    # typiskt
    # hostsblock
    keymapp
    wiki-tui

    # --- Fonts ---
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
    inter
    # nerd-fonts.inter

    # --- Gnome & GTK ---
    gtk3
    gtk4
    libadwaita
    adwaita-icon-theme
    material-cursors
    lyra-cursors
    adwaita-qt

    nautilus
    gnome-control-center
    gnome-system-monitor
    gnome-disk-utility
    gnome-online-accounts
    wrapGAppsHook4
    gsettings-desktop-schemas
    glib
    glib-networking
    gnome-settings-daemon
    # gnome-session
    # gvfs-goa
    google-drive-ocamlfuse
    # gvfs-smb
    # gvfs-nfs
    # gvfs-mtp
    gnome-keyring
    gvfs

    # --- KDE / Qt ---
    # oauth2l
    # oauth2c
    # oauth2-proxy
    libsForQt5.signond
    kdePackages.dolphin
    kdePackages.kaccounts-providers
    kdePackages.kaccounts-integration
    kdePackages.signond
    kdePackages.signon-kwallet-extension
    kdePackages.systemsettings
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kio
    kdePackages.kio-gdrive
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kalm
    kdePackages.artikulate
    kdePackages.ktouch

    # inputs.Akari.packages.${system}.default
    entr
  ];
}
