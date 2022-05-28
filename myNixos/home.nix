{ config, pkgs, nixpkgs, lib, ... }:

{
  imports = [
    ./vim.nix
  ];

  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      pcmanfm gvfs udisks xarchiver
      xfce.tumbler poppler ffmpegthumbnailer libgsf gnome.totem evince mcomix3 
      gruvbox-dark-gtk
      gruvbox-dark-icons-gtk material-design-icons
      numix-cursor-theme quintom-cursor-theme bibata-cursors
      themechanger
      anki
      ripgrep fd bat
      pandoc emacs28Packages.emacsql emacs28Packages.emacsql-sqlite
      xorg.xwininfo xdotool xclip lispPackages.clsql-sqlite3
    ];
  };

}
