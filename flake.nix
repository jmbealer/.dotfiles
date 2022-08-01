{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
    url  = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  # outputs = { self, nixpkgs, home-manager, ... }:
  outputs = inputs @ { self, nixpkgs, home-manager, nur, ... }:
    let
      user = "jb";
      location = "$HOME/dotfiles";
      protocol = "X";
      # system = "x86_64-linux";
      # pkgs = import nixpkgs {
        # inherit system;
        # config.allowUnfree = true;
      # };
      # lib = nixpkgs.lib;
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nur user location protocol;
        }
      );
        # jb = lib.nixosSystem {
          # inherit system;
          # modules = [ 
            # ./configuration.nix 
            # home-manager.nixosModules.home-manager {
              # home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              # home-manager.users.jb = {
                # imports = [ ./home.nix ];
              # };
            # }
          # ];
        # };
      # };
      homeConfigurations = ( 
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user;
        }
      );
    };


}
