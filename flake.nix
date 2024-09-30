{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixvim-flake.url = "github:dembezum/nixvim";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
    let
      systemSettings = {
        systemstate = "24.05";
        host = "zumClust-REV";
        system = "x86_64-linux";
        hostname = "${systemSettings.host}";
      };

      userSettings = {
        username = "zumClust-REV";
        name = "zumClust-REV";
        editor = "nvim";
        term = "xterm-256color";
        terminal = "foot";
        browser = "firefox";
        video = "mpv";
        image = "feh";
        homestate = "24.05";
      };

    in {
      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [
            ./hosts/${systemSettings.host}/configuration.nix
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            inputs.home-manager.nixosModules.default
            inputs.disko.nixosModules.disko
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${userSettings.username} =
                  let pkgs = nixpkgs.legacyPackages.${systemSettings.system};
                  in import ./hosts/${systemSettings.host}/home.nix {
                    inherit inputs pkgs systemSettings userSettings;
                  };
              };
            }
          ];
          specialArgs = { inherit systemSettings userSettings inputs; };
        };
      };
    };
}
