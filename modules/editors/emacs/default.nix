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

  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];

  environment.systemPackages = with pkgs; [
    # emacs
    ripgrep
    coreutils
    fd

    emacsGcc
    # emacsNativeComp
    sqlite
    pandoc
    emacs28Packages.emacsql
    emacs28Packages.emacsql-sqlite
    emacs28Packages.emacsql-sqlite-module
    emacs28Packages.emacsql-sqlite-builtin
    lispPackages.clsql-sqlite3


      ## Emacs itself
      # binutils       # native-comp needs 'as', provided by this
      # 29 + pgtk + native-comp
      # ((emacsPackagesFor emacsPgtkGcc).emacsWithPackages (epkgs: [

      # ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
        # epkgs.vterm
      # ]))

      ## Doom dependencies
      git
      # (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      # fd                  # faster projectile indexing
      imagemagick         # for image-dired
      # (mkIf (config.programs.gnupg.agent.enable)
        # pinentry_emacs)   # in-emacs gnupg prompts
      zstd                # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [
        en en-computers en-science
      ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      # sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      # beancount
      # unstable.fava  # HACK Momentarily broken on nixos-unstable

  ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

}
