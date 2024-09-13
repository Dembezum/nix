{ systemSettings, userSettings, ... }:

{
  imports = [ ../../universal.nix ../../modules/system/ssh ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
  };

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "plugdev" "networkmanager" "wheel" ];
    uid = 1000;
  };

  networking = {
    hostName = systemSettings.hostname;
    interfaces = { ens18 = { useDHCP = true; }; };
    #    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = systemSettings.systemstate;
}
