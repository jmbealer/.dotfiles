{ config, pkgs, nixpkgs, lib, ... }:

{
  imports = [
    ./vim.nix
    ./bspwm.nix
    # ./st.nix
  ];

  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      pcmanfm gvfs udisks xarchiver
      xfce.tumbler poppler ffmpegthumbnailer libgsf gnome.totem evince mcomix3
      gruvbox-dark-gtk
      gruvbox-dark-icons-gtk material-design-icons
      numix-cursor-theme quintom-cursor-theme bibata-cursors
      themechanger kitty
      anki
      ripgrep fd bat polybar
      sqlite
      pandoc emacs28Packages.emacsql emacs28Packages.emacsql-sqlite
      emacs28Packages.emacsql-sqlite-module emacs28Packages.emacsql-sqlite-builtin
      xorg.xwininfo xdotool xclip lispPackages.clsql-sqlite3
      gh
      helvum qpwgraph qjackctl
      bash-completion nix-bash-completions nodePackages.bash-language-server
      tealdeer
      cmake nodePackages.npm shellcheck shellharden nixfmt coreutils-full
      gnumake
    ];
  };

  programs.git = {
    enable = true;
    userName = "Justin Bealer";
    userEmail = "jmbealer11@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.ff = "only";
      url."https://github.com/".insteadOf = "git://github.com";
    };
    # extraConfig = {
      # credential.helper = "${
        # pkgs.git.override { withLibsecret = true; }
      # }/bin/git-credential-libsecret";
    # };
  };

}
