{ inputs, systemSettings, userSettings, pkgs, ... }:

{
  imports = [
    ./disko-config.nix
    ../../universal.nix
    ../../modules/system
    ../../modules/services/tailscale
    ../../modules/services/rsyslog
    ./hardware-configuration.nix
  ];

  nix.distributedBuilds = true;
  services.xe-guest-utilities.enable = true;

  environment = {
    variables = { };
    systemPackages = with pkgs; [
      inputs.nixvim-flake.packages.${system}.default
      xe-guest-utilities

    ];
  };

  networking = {
    hostName = systemSettings.hostname;
    interfaces = {
      enX0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.0.41.10";
          prefixLength = 24;
        }];
      };
    };
    defaultGateway = "10.0.41.1";
    nameservers = [ "1.1.1.1" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  boot = {
    loader.grub = {
      devices = [ "/dev/xvda" ];
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  users.users.${userSettings.username} = {
    description = userSettings.name;
    isNormalUser = true;
    initialPassword = "frysepizza";
    extraGroups = [ "docker" "plugdev" "libvirt" "networkmanager" "wheel" ];
    uid = 1000;
  };

  system.stateVersion = systemSettings.systemstate;
}
