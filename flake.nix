{
  description = "Xoviax's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, 
           nixpkgs, 
           home-manager, 
           stylix, 
           antigravity-nix, 
           ... }@inputs: 
    let
      system = "x86_64-linux";
    in {
    nixosConfigurations = {
      zafkiel = nixpkgs.lib.nixosSystem {
        inherit system;
        
        specialArgs = { inherit inputs; }; 

        modules = [
          ./hosts/thinkpad/hardware-configuration.nix
          ./hosts/thinkpad/configuration.nix
          
          stylix.nixosModules.stylix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            
            home-manager.users.xoviax = import ./modules/home/home.nix;

            home-manager.extraSpecialArgs = { inherit inputs; inherit system; };
          }
        ];
      };
    };
  };
}