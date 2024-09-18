{ pkgs, ... }:

# --- VPN CONFIGURATION ---
{
  environment.systemPackages = with pkgs;
    [
      tailscale

    ];

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 ];
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
