{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url  = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, utils, ... }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        jb = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix 
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jb = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
    };

    overlays = (final: prev: {
      dwm = prev.dwm.overrideAttrs
        (old: rec {
          name = "dwm-custom";
          src = ./dwm;
        });

      dmenu = prev.dmenu.overrideAttrs (old: rec {
        name = "dmenu-custom";
        src = ./dmenu;
      });

      st = prev.st.overrideAttrs (old: rec {
        name = "st-custom";
        buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
        src = ./st;
      });

      slstatus = prev.slstatus.overrideAttrs (old: rec {
        name = "slstatus-custom";
        src = ./slstatus;
      });

      slock = prev.slock.overrideAttrs (old: rec {
        name = "slock-custom";
        buildInputs = old.buildInputs ++ [
          prev.xorg.libXinerama
          prev.xorg.libXft
        ];
        src = ./slock;
      });
    });

}
