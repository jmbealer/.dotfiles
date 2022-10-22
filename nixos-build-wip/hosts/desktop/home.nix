{ pkgs, ...}:

{
  imports = [
    ../../modules/desktop/bspwm/home.nix
  ];

  home = {
    packages = with pkgs; [

    ];
  };

  programs = {
    alacritty.settings.font.size = 11;
  };

  services = {
    blueman-applet.enable = true;
  };

}
