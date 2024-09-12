{ systemSettings, userSettings, pkgs, ... }:

{
  imports = [
    ../../universal.nix
    ../../modules/system/ssh
    ../../modules/system/glances
    ../../modules/system/librenms
    ../../modules/system/dhcpserver
    ./hardware-configuration.nix
  ];

  environment = {
    variables = {

    };
    systemPackages = with pkgs;
      [
        inputs.nixvim-flake.packages.${system}.default

      ];
  };

  networking = {
    hostName = systemSettings.hostname;
    interfaces = {
      ens18 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.0.40.10";
          prefixLength = 24;
        }];
      };
    };
    defaultGateway = "10.0.40.1";
    nameservers = [ "1.1.1.1" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 81 22 443 3306 22000 ];
    allowedUDPPorts = [ ];
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/xda";
    useOSProber = true;
  };

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "plugdev" "networkmanager" "wheel" ];
    uid = 1000;
  };

  system.stateVersion = systemSettings.systemstate;
}
