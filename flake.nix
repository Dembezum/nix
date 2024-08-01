{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    ... }@inputs: let 

    # --- SYSTEM CONFIGURATION ---
    systemSettings = {
      system = "x86_64-linux";
      host = "nixkube1";
      hostname = "nixkube1";
      systemstate = "23.11";
    };

    # --- USER CONFIGURATION ---
    userSettings = {
      username = "nixkube1";
      name = "nixkube1";
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
