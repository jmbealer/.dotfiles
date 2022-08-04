{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
                                # and packages.el files
  };
in {
  home.packages = [ doom-emacs ];
}


# { config, pkgs, callPackage, ... }:
# { 

  # services.emacs.package = pkgs.emacsUnstable;

  # nixpkgs.overlays = [
    # (import (builtins.fetchTarball {
      # url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      # sha256 = "09wv9mfb94ac19mbb6s3b3kkq52jk4475l4lh4gdxb3kk3j2bwsd";
    # }))
  # ];

  # services.emacs.package = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [ epkgs.vterm ]));

  # services.emacs.enable = true;

  # environment.systemPackages = with pkgs; [
    # ripgrep
    # coreutils
    # fd
    # sqlite
    # emacs28Packages.emacsql
    # emacs28Packages.sqlite
    # emacs28Packages.magit-section
    # filenotify-recursive
    # (emacsWithPackagesFromUsePackage { 
      # config = ./doom.d/config.el;
      # package = pkgs.emacsGitNativeComp;
      # package = pkgs.emacsGitNativeComp;
      # alwaysEnsure = true;
      # alwaysTangle = true;
      # extraEmacsPackages = epkgs: [
        # epkgs.cask
        # epkgs.org-roam
      # ];
    # })
  # ];

    # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

# }
