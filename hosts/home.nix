# { config, pkgs, nixpkgs, lib, ... }:
{ config, lib, pkgs, user, ... }: {
  # imports = [
    # ./vim.nix
    # ./bspwm.nix
    # ./st.nix
  # ];

  imports =
    (import ../modules/editors) ++
    (import ../modules/programs) ++
    (import ../modules/services) ++
    # (import ../modules/services);
    (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      gnumake
      pcmanfm
      gvfs
      udisks
      xarchiver
      xfce.tumbler poppler ffmpegthumbnailer libgsf gnome.totem evince mcomix3
      gruvbox-dark-gtk
      gruvbox-dark-icons-gtk material-design-icons
      numix-cursor-theme quintom-cursor-theme bibata-cursors
      themechanger kitty



      gh
      helvum qpwgraph qjackctl
      bash-completion nix-bash-completions

      # nodePackages.bash-language-server

      tealdeer
      cmake
      shellcheck shellharden nixfmt
      trash-cli

      # nodePackages.npm


      anki-bin
      gcc


      # vim_configurable

      git alacritty stow dmenu lf
      coreutils-full

      # clang

      gcc
      arandr

      # iosevka

      tmux neofetch starship
      libcap go unzip
      exa
      git-crypt gnupg

      # gcc-wrapper

      # cope
      firefox-devedition-bin
      feh sxhkd

      # st

      # from newer dotfiles
      bind
      cached-nix-shell


      # need move to right place
      bat
      fasd
      fzf
      jq


      siduck76-st redshift xbanish unclutter
      ttyper klavaro gotypist
      lxappearance
      qbittorrent
      ueberzug
      dconf

      libcap go gcc
      xdg-utils

      # binutils

      xdg-desktop-portal-gtk
      ungoogled-chromium
      lshw
      flameshot
      graphviz
      html-tidy

      # nodePackages.stylelint

      # nodePackages.js-beautify

      rclone
      vscode-fhs
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator
      zathura
      postman
      zoom-us
      perl534Packages.FileMimeInfo
      ueberzug
      wkhtmltopdf
      python310Packages.pdftotext
      nodePackages.vercel
      heroku
      wally-cli
      zsa-udev-rules
      thunderbird-bin
      mpv
      blesh
      dbeaver
      xorg.xmodmap

      exiftool
      chafa
      atool
      unrar
      jq
      python310Packages.pdf2image
      delta
      highlight
      sourceHighlight
      python3Full

      # python39Packages.setuptools
      # python310Packages.setuptools
      # python310Packages.debugpy
      python310Packages.pip
      file

      texlive.combined.scheme-basic
      # nodePackages.gulp

      cpu-x
      polkit_gnome

      jackett

      lxde.lxmenu-data
      shared-mime-info

      # wineWowPackages.stable
      wineWowPackages.staging
      winetricks
      lutris

      gdb
      # lldb

      rename

      dict
      goldendict
      artha

      brave
      slack

      xdg-user-dirs
    ];

    # file.".config/wall".source = ../modules/themes/wall;
    pointerCursor = {
      name = "Numix-Cursor-Light";
      package = pkgs.numix-cursor-theme;
      size = 16;
    };
		stateVersion = "21.11";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
    font = {
      name = "Iosevka Nerd Font";
    };
  };

  # programs.git = {
    # enable = true;
    # userName = "Justin Bealer";
    # userEmail = "jmbealer11@gmail.com";
    # extraConfig = {
      # init.defaultBranch = "main";
      # pull.ff = "only";
      # url."https://github.com/".insteadOf = "git://github.com";
    # };
    # extraConfig = {
      # credential.helper = "${
        # pkgs.git.override { withLibsecret = true; }
      # }/bin/git-credential-libsecret";
    # };
  # };

}
