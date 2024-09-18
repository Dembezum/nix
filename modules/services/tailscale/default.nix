{ pkgs, ... }:

# --- VPN CONFIGURATION ---
{
  environment.systemPackages = with pkgs;
    [
      tailscale

    ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
