{ config, pkgs, callPackage, ... }:
{ 

  services.emacs.package = pkgs.emacsUnstable;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "09wv9mfb94ac19mbb6s3b3kkq52jk4475l4lh4gdxb3kk3j2bwsd";
    }))
  ];

  # services.emacs.package = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [ epkgs.vterm ]));

  services.emacs.enable = true;

  environment.systemPackages = with pkgs; [
    ripgrep
    coreutils
    fd
    (emacsWithPackagesFromUsePackage { 
      config = ./doom.d/config.el;
      package = pkgs.emacsGitNativeComp;
      alwaysEnsure = true;
      alwaysTangle = true;
      extraEmacsPackages = epkgs: [
        epkgs.cask
      ];
    })
  ];
  # environment.systemPackages = [

    # (emacsWithPackagesFromUsePackage {
      # config = # rm -r $HOME/.doom.d
      # package = pkgs.emacsGit;

      # package = pkgs.emacsGitNativeComp;
      # alwaysEnsure = true;
      # alwaysTangle = true;
      # extraEmacsPackages = epkgs: [
        # epkgs.cask
      # ];
    # })
  # ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

}
