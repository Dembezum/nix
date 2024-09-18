{
  networking.firewall.allowedTCPPorts = [ 90 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "dembezuuma@gmail.com";
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "zumserve.dev" = {
        serverName = "zumserve.com";
        root = "/sites/zumserve.com/src/public";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          extraConfig = ''
            index index.html;
          '';
        };
      };
    };
  };
}
