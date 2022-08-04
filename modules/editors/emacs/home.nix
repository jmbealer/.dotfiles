{ pkgs, callPackage, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
    sha256 = "09wv9mfb94ac19mbb6s3b3kkq52jk4475l4lh4gdxb3kk3j2bwsd";
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
                                # and packages.el files
  };
in {
  home.packages = [ doom-emacs ];
}
