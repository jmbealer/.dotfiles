#  These are the different profiles that can be used when building NixOS.

#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 

{ lib, inputs, nixpkgs, home-manager, nur, user, location, doom-emacs, protocol, ... }:

let
  # System architecture
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    # Allow proprietary software
    config.allowUnfree = true; 
  };

  lib = nixpkgs.lib;
in {

  # desktop = lib.nixosSystem { # Desktop profile
    # inherit system;
    # specialArgs = { inherit inputs user location protocol; }; # Pass flake variable
    # modules = [
      # nur.nixosModules.nur
      # ./desktop
      # ./configuration.nix

      # home-manager.nixosModules.home-manager { # Home-Manager module that is used.
        # home-manager.useGlobalPkgs = true;
        # home-manager.useUserPackages = true;
        # home-manager.extraSpecialArgs = { inherit user protocol; }; # Pass flakes variable
        # home-manager.users.${user} = {
          # imports = [(import ./home.nix)] ++ [(import ./desktop/home.nix)];
        # };
      # }
    # ];
  # };

  # Laptop profile
  laptop = lib.nixosSystem { 
    inherit system;
    specialArgs = { inherit inputs user location protocol; };
    modules = [
      nur.nixosModules.nur
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user protocol; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
        };
      }
    ];
  };

  # vm = lib.nixosSystem { # VM profile
    # inherit system;
    # specialArgs = { inherit inputs user location; };
    # modules = [
      # ./vm
      # ./configuration.nix

      # home-manager.nixosModules.home-manager {
        # home-manager.useGlobalPkgs = true;
        # home-manager.useUserPackages = true;
        # home-manager.extraSpecialArgs = { inherit user; };
        # home-manager.users.${user} = {
          # imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        # };
      # }
    # ];
  # };

}
