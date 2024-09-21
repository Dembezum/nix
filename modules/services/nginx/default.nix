{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    nginx
    certbot

  ];

  networking.firewall.allowedTCPPorts = [ 80 8080 90 91 8443 443 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "dembezuuma@gmail.com";
    certs = {
      "zumserve.com" = {
        webroot = "/sites/zumserve.com/src/public";
        email = "dembezuuma@gmail.com";
        domain = "zumserve.com";
        extraDomainNames = [ "www.zumserve.com" ];
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "zumserve.com" = {
        serverName = "zumserve.com";
        root = "/sites/zumserve.com/src/public";
        listen = [{
          port = 80;
          addr = "10.0.40.101";
        }];

        locations."/.well-known/acme-challenge/" = {
          root = "/sites/zumserve.com/src/public";
        };

        locations."/" = {
          root = "/sites/zumserve.com/src/public";

        };
      };
    };
  };
}
