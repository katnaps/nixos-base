{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations = {
        nixos-fruit = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [

            ./configuration.nix
            ./modules/nvidia.nix
            ./modules/bluetooth.nix
            ./modules/keyboard.nix
            ./modules/controller.nix

            {
              nixpkgs.overlays = [
                (import ./overlays/unstable.nix inputs)
              ];
            }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.katnaps = import ./home-manager/home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
