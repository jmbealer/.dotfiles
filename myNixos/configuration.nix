# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hosts.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables = {
    SUDO_EDITOR = "vim";
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";


  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [ "10.26.0.1" "104.223.91.195" "104.223.91.210" ]; 

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0f1.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.windowManager.bspwm.enable = true;
  # services.xserver.windowManager.bspwm.configFile = "/home/jb/.dotfiles/bspwmrc";
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.libinput.enable = true;

  # gtk/qt themes
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";

  # picom
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
          };
        };
      }
      { matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
      ];}
    ];
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    # General = {
      # Enable = "Source,Sink,Media,Socket";
    # };
  };
  services.blueman.enable = true;
  


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jb = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzlS2DsemrWjubPRw5WzqYYJOvWjLzYwBslvUpnzVkX jmbealer11@gmail.com"
    ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim_configurable git alacritty stow dmenu lf coreutils-full
    xdg-utils clang gcc binutils
    arandr iosevka tmux neofetch starship
    libcap go
    exa
    git-crypt gnupg
    # gcc-wrapper gnumake
    cope
    wget
    firefox-devedition-bin
    feh sxhkd
    st
  ];

  # add fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode" "Iosevka"]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = false;
    # pinentryFlavor = "qt";
  # };

  programs.ssh.askPassword = "";
  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    # challengeResponseAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  # environment.extraInit = ''
    # unset -v SSH_ASKPASS
  # '';


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

system.autoUpgrade.enable = true;
# system.autoUpgrade.allowReboot = true;

services.emacs.enable = true;
	
}
