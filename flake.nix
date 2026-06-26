{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Pinned repo for BlueZ 5.84
    nixpkgs-bluez.url = "github:nixos/nixpkgs/b86751bc4085f48661017fa226dee99fab6c651b";

    # Hyprland repo
    hyprland.url = "github:hyprwm/Hyprland";

    # Home manager repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
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

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.coconut = import ./home-manager/home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
