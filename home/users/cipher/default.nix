{
  config,
  pkgs,
  inputs,
  sops,
  ...
}: {
  # Personal Home Manager profile for user 'cipher'.
  # Shared baseline lives in home/common/; this file holds
  # user-specific settings (secrets, themes, mime apps).
  imports = [
    ../../common/default.nix
    ../../common/shell.nix
    ../../../modules/home/editors/nvf.nix
    ../../../modules/home/desktop/rofi.nix
  ];

  home = {
    # Home Manager Metadata
    username = "cipher";
    homeDirectory = "/home/cipher";
    # stateVersion = "25.05"; # Check release notes before changing
    stateVersion = "26.05"; # Check release notes before changing
  };

  # Secrets Management (SOPS)
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
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
    configFile."hypr".source = ../../../modules/home/desktop/hyprland/configs;
    configFile."waybar".source = ../../../modules/home/desktop/waybar;

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
      # name = pkgs.lib.mkForce "Flat-Remix-GTK-Blue-Darkest";
      # package = pkgs.lib.mkForce pkgs.flat-remix-gnome;
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
    platformTheme.name = "gtk3";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };
}
