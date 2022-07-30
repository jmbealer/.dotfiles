{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [ inputs.home-manager.nixosModules.home-manager ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;


  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault false;

  # Use the latest kernel
  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_hardened;
    # kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_5_16;
    # kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_5_18;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    vim
    wget
    gnumake
    unzip

    # need move to right place
	    lf
      bat
      exa
      fasd
      fd
      fzf
      jq
      ripgrep
      neofetch
      starship


    vim_configurable
    alacritty
    arandr
    iosevka
    firefox-devedition-bin

      pcmanfm gvfs udisks xarchiver
      xfce.tumbler poppler ffmpegthumbnailer libgsf gnome.totem evince mcomix3
      gruvbox-dark-gtk
      gruvbox-dark-icons-gtk material-design-icons
      numix-cursor-theme quintom-cursor-theme bibata-cursors
      themechanger
      # anki
      # anki-bin
      ripgrep fd bat polybar
      sqlite
      xorg.xwininfo xdotool xclip lispPackages.clsql-sqlite3
      gh
      helvum qpwgraph qjackctl
      bash-completion nix-bash-completions nodePackages.bash-language-server
      tealdeer
      cmake nodePackages.npm shellcheck shellharden nixfmt coreutils-full
      gcc
      trash-cli
    pandoc siduck76-st redshift xbanish unclutter
    ttyper klavaro gotypist
    lxappearance
    qbittorrent
    ueberzug
    dconf

    # networkmanagerapplet networkmanager-openvpn wireguard-tools
    libcap go gcc
    xdg-utils clang binutils
    xdg-desktop-portal-gtk

  ungoogled-chromium

    lshw
    flameshot

    graphviz
    html-tidy
    nodePackages.stylelint
    nodePackages.js-beautify
    rclone

    vscode-fhs

    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator

    # zathura-with-plugins
    zathura
    postman

    zoom
  ];

  # add fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode" "Iosevka"]; })
  ];

  # X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;
  hardware.video.hidpi.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.libinput.enable = true;
  # services.xserver.dpi = 96;
  services.xserver.dpi = 85;
  networking.nameservers = [ "104.223.91.195" "104.223.91.210" ];
  services.blueman.enable = true;
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.mime.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # xdg.portal.gtkUsePortal.enable = true;

  # services.openvpn.servers = {
    # torguardVPN = { config = '' config /home/jb/Download/14.onc ''; };
  # };

services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
services.dbus.packages = with pkgs; [ gnome2.GConf ];
services.accounts-daemon.enable = true;

services.gnome.gnome-settings-daemon.enable = true;
services.gnome.core-utilities.enable = true;


}
