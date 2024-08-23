{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixvim-flake.url = "github:dembezum/nixvim";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};

      # --- SYSTEM CONFIGURATION ---
      systemSettings = {
        system = "x86_64-linux";
        host = "nixkia";
        hostname = "nixkia";
        systemstate = "23.11";
      };

      # --- USER CONFIGURATION ---
      userSettings = {
        username = "nixkia";
        name = "nixkia";
        editor = "nvim";
        term = "xterm-256color";
        terminal = "foot";
        browser = "firefox";
        video = "mpv";
        image = "feh";
        homestate = "23.11";
      };

      #      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ./hosts/${systemSettings.host}/configuration.nix
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            inputs.home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${userSettings.username} =
                  import ./hosts/${systemSettings.host}/home.nix {
                    inherit inputs pkgs systemSettings userSettings;
                  };
              };
            }
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };
}
