{ systemSettings, userSettings, pkgs, ... }:

{
  imports = [
    ../../universal.nix
      ../../modules/system/ssh
  ];

  environment.systemPackages = with pkgs; [ 
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
};

  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        set cc=80
        set number
        set relativenumber
        set hlsearch = false
        set incsearch = true
        set swapfile = false
        set cursorline = true
        set virtualedit = "block"
        endif
        '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ ctrlp ];
      };
    };
  };

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "plugdev" "networkmanager" "wheel" ];
    uid = 1000;
  };

  networking = {
    hostName = systemSettings.hostname;
    interfaces = {
      ens18 = {
        useDHCP = true;
      };
    };
    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = systemSettings.systemstate;
}
