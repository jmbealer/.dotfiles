{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # lazyvim = {
    #   url = "github:pfassina/lazyvim-nix";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dms-cli = {
      # url = "github:AvengeMedia/danklinux";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
      # inputs.dms-cli.follows = "dms-cli";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    Akari = {
      url = "github:spector700/Akari";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim = {
    # url = "github:nix-community/nixvim";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      # self,
      nixpkgs,
      # home-manager,
      # mango,
      # lazyvim,
      # hosts,
      # dankMaterialShell,
      # stylix,
      ...
    }@inputs:
    {
      nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.mango.nixosModules.mango
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          # inputs.nixvim.nixosModules.nixvim
          # inputs.Akari.nixosModules.Akari
          inputs.hosts.nixosModule
          {
            # networking.stevenBlackHosts.enable = true;
            networking.stevenBlackHosts = {
              enable = true;
              enableIPv6 = true;
              blockFakenews = true;
              blockGambling = true;
              # blockPorn = true;
              # blockSocial = true;
            };
          }
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # users."0xjb" = import ./home.nix { inherit lazyvim; };
              # users."0xjb" = import ./home.nix;
              users."0xjb" = {
                imports = [
                  ./home.nix
                  # inputs.lazyvim.homeManagerModules.default
                  inputs.dankMaterialShell.homeModules.dankMaterialShell.default
                  inputs.sops-nix.homeManagerModules.sops
                  inputs.nvf.homeManagerModules.default
                ];
              };
              backupFileExtension = "backup";
              sharedModules = [
              ];
            };
          }
        ];
      };
    };

}
