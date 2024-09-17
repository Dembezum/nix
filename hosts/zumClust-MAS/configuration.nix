{ inputs, systemSettings, userSettings, pkgs, ... }:

{
  imports = [
    ./disko-config.nix
    ../../universal.nix
    ../../modules/services
    ../../modules/system/ssh
    ../../modules/system/glances
    ../../modules/system/virtualization
    ./hardware-configuration.nix
  ];

  environment = {
    variables = { };
    systemPackages = with pkgs; [
      inputs.nixvim-flake.packages.${system}.default
      docker-compose

    ];
  };

  networking = {
    hostName = systemSettings.hostname;
    interfaces = {
      enX0 = {
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
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "docker" "plugdev" "libvirt" "networkmanager" "wheel" ];
    uid = 1000;
  };

  system.stateVersion = systemSettings.systemstate;
}
