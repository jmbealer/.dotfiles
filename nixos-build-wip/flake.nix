#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix

{
  description = "NixOS System Flake Configuration";

  # All flake reference used to build my NixOS setup. These are
  # dependencies.
  inputs = {
    # Nix Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # User Package Management
    home-manager = {
    url  = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR Packages
    nur.url = "github:nix-community/NUR";
    # OpenGL
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Emacs Overlays
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
    # Nix-community Doom Emacs
    doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
  };
  # Function that tell my flake which to use and what do what to do with
  # the dependencies.
  outputs = inputs @ { self, nixpkgs, home-manager, nur, nixgl, doom-emacs, ... }:
    # Variable that can be used in the config files.
    let
      user = "jb";
      location = "$HOME/dotfiles";
      protocol = "X";
    # Use above variables in ...
    in {
      # NixOS configurations
      nixosConfigurations = (
        # Imports ./hosts/default.nix
        import ./hosts {
          inherit (nixpkgs) lib;
          # Also inherit home-manager so it does not need to be defined
          # here.
          inherit inputs nixpkgs home-manager nur user location doom-emacs protocol;
        }
      );
      # Non-NixOS configurations
      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nixgl user;
        }
      );
    };
}
