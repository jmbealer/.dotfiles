{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./hosts.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      apps = {
        rofi.enable = true;
        # godot.enable = true;
      };
      browsers = {
        default = "firefox";
        # brave.enable = true;
        firefox.enable = true;
        # qutebrowser.enable = true;
      };
      gaming = {
        # steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        daw.enable = true;
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        # spotify.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      # python.enable = true;
    };
    editors = {
      default = "emacs";
      emacs.enable = true;
      vim.enable = true;
    };
    shell = {
      adl.enable = true;
      vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      tmux.enable   = true;
      # bash.enable   = true;
      # zsh.enable    = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  programs.dconf.enable = true;

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = {
      # InTown_Guest = {
        # psk="bush0705";
	      # pskRaw="a1f4e83014cec327799cde4c3f2a4bb56b7c023ccbacd2d0ea43a2563b1f200c";
      # };
      InTown_Guest = {};
      # FreeWifi = {};
    };
  };
  # networking.wireless.enable = true;
  # networking.wireless.userControlled.enable = true;
  # networking.networkmanager.enable = true;

  # networking.wireless.networks = {
    # InTown_Guest = {
	    # pskRaw="a1f4e83014cec327799cde4c3f2a4bb56b7c023ccbacd2d0ea43a2563b1f200c";
    # };
  # };


  time.timeZone = "America/Chicago";
}
