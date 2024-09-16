# disko-config
{
  imports = [ <nixos-hardware/x86_64/xcp-ng> ];

  disko = {
    enable = true;
    devices = {
      "/dev/xvda" = {
        partitions = {
          # Boot partition
          boot = {
            start = "0";
            size = "512MiB";
            type = "primary";
            format = {
              fstype = "ext4";
              mountPoint = "/boot";
            };
          };

          # Root partition
          root = {
            start = "512MiB";
            size = "100%-4GiB"; # Adjust size to leave space for swap
            type = "primary";
            format = {
              fstype = "ext4";
              mountPoint = "/";
            };
          };

          # Swap partition
          swap = {
            start = "100%-4GiB";
            size = "4GiB";
            type = "primary";
            format = { fstype = "swap"; };
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/xvda2";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/xvda1";
      fsType = "ext4";
    };
  };

  swapDevices = [{
    device = "/dev/xvda3";
    priority = 1;
  }];

  # Additional NixOS configuration
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/xvda";
  };

}
