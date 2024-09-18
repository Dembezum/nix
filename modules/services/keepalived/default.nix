{
  services.keepalived = {
    enable = true;
    virtualRouterId = 51; # Choose a unique VRID between 0-255
    state = "MASTER"; # On the primary, change to "BACKUP" on the other two
    interface = "enX0"; # Replace with the appropriate network interface
    virtualIps = [ "10.0.41.10" ]; # Replace with your desired VIP
    priority =
      100; # Higher number indicates higher priority; adjust for backup hosts
    unicastPeerIps =
      [ "10.0.40.200" "10.0.40.300" ]; # IPs of other hosts in the cluster
  };
}
