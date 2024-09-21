{ inputs, systemSettings, userSettings, pkgs, ... }:

{
  imports = [
    ./disko-config.nix
    ./keepalived.nix
    ../../universal.nix
    ../../modules/system
    ../../modules/services
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
          address = "10.0.40.200";
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
    openssh.authorizedKeys.keys = [''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObwpxQ2jEJLHmwx6hBHbhveBs7UWeM31JdUH7vkPcVM dembezuuma@gmail.com
    '' # content of authorized_keys file
      # note: ssh-copy-id will add user@your-machine after the public key
      # but we can remove the "@your-machine" part
      ];
    uid = 1000;
  };

  system.stateVersion = systemSettings.systemstate;
}
