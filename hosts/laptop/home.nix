{ pkgs, ...}:

{
  imports = [
    ../../modules/desktop/bspwm/home.nix
    # ../../modules/editors/emacs/default.nix
    # ../../modules/editors/emacs/home.nix
  ];

  # home = {
    # packages = with pkgs; [

    # ];
  # };

  programs = {
    alacritty.settings.font.size = 11;
  };

  services = {
    blueman-applet.enable = true;
  };

}
