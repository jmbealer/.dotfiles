{ config, pkgs, location, ... }:

{ 
  services.emacs.enable = true;

  system.userActivationScripts = {
    doomEmacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        DOOM="$HOME/.emacs.d"

        if [ ! -d "$DOOM" ]; then
          git clone https://github.com/hlissner/doom-emacs.git $DOOM
          yes | $DOOM/bin/doom install
          rm -r $HOME/.doom.d
          ln -s ${location}/modules/editors/emacs/doom.d $HOME/.doom.d
          $DOOM/bin/doom sync
        else
          $DOOM/bin/doom sync
        fi
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    # emacs
    ripgrep
    coreutils
    fd

    sqlite
    pandoc
    emacs28Packages.emacsql
    emacs28Packages.emacsql-sqlite
    emacs28Packages.emacsql-sqlite-module
    emacs28Packages.emacsql-sqlite-builtin
    lispPackages.clsql-sqlite3
  ];

}
