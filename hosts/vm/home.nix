{ pkgs, ...}:

{
  imports = [
    ../../modules/desktop/bspwm/home.nix
  ];

  home = {
    packages = with pkgs; [
      firefox
    ];
  };


}
