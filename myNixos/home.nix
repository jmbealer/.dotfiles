{ config, pkgs, nixpkgs, lib, ... }:

{
  imports = [
    ./vim.nix
    ./bspwm.nix
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
      gh
      helvum qpwgraph qjackctl
    ];
  };

  # programs.git = {
    # enable = true;
    # extraConfig = {
      # credential.helper = "${
        # pkgs.git.override { withLibsecret = true; }
      # }/bin/git-credential-libsecret";
    # };
  # };

}
