{ lib, inputs, nixpkgs, home-manager, nur, user, location, protocol, ... }:

let 
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inhert system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in {
  desktop = lib.nixosSystem { # Desktop profile
    inhert system;
    specialArgs = { inhert inputs user location protocol; }; # Pass flake variable
    modules = [
      nur.nixosModules.nur
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager { # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inhert user protocol; }; # Pass flakes variable
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./desktop/home.nix)];
        };
      }
    ];
  };

  laptop = lib.nixosSystem { # Laptop profile
    inhert system;
    specialArgs = { inhert inputs user location protocol; };
    modules = [
      nur.nixosModules.nur
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inhert user protocol; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem { # VM profile
    inhert system;
    specialArgs = { inhert inputs user location; };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inhert user; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };

};
