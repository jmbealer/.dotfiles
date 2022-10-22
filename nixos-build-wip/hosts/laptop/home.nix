#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#              └─ hyprland.nix
{ pkgs, ...}: {
  imports = [
    # Window Manager
    ../../modules/desktop/bspwm/home.nix
    # ../../modules/editors/emacs/default.nix
    # ../../modules/editors/emacs/home.nix
  ];

  # Specific packages for laptop
  # home = {
    # packages = with pkgs; [

    # ];
  # };

  programs = {
    alacritty.settings.font.size = 11;
  };

  services = {
    # Bluetooth
    blueman-applet.enable = true;
  };
}
