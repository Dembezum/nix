{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    nixos-wsl,
    ... }@inputs: let 

    # --- SYSTEM CONFIGURATION ---
    systemSettings = {
      system = "x86_64-linux";
      host = "nixos";
      hostname = "nixos";
      systemstate = "24.05";
    };

    # --- USER CONFIGURATION ---
    userSettings = {
      username = "nixos";
      name = "nixos";
      editor = "nvim";
      term = "xterm-256color";
      terminal = "foot";
      browser = "firefox";
      video = "mpv";
      image = "feh";
      homestate = "23.11";
    };


    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${systemSettings.system};

in {
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          ./hosts/${systemSettings.host}/configuration.nix
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userSettings.username} = import ./hosts/${systemSettings.host}/home.nix { inherit pkgs systemSettings userSettings; };
          }
        ];
        specialArgs = {
          inherit systemSettings userSettings inputs;
        };
      };
    };
  };
}
