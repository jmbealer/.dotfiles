{
  config,
  lib,
  pkgs,
  ...
}: {
  # Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portals (Hyprland-aware)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
  };

  # swaync is started by Hyprland's autostart.conf instead
  systemd.user.services.swaync.enable = false;
}
