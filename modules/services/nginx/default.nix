{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    nginx
    openssl

  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "dembezuuma@gmail.com";
    certs = {
      "zumserve.com" = {
        webroot = "/var/lib/acme/challenges-zumserve";
        email = "dembezuuma@gmail.com";
        group = "nginx";
        domain = "zumserve.com";
        extraDomainNames = [ "www.zumserve.com" ];
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    logError = "stderr info";
    virtualHosts = {

      "zumserve.com" = {
        addSSL = true;
        useACMEHost = "zumserve.com";
        serverAliases = [ "*.zumserve.com" ];
        acmeRoot = "/var/lib/acme/challenges-zumserve";
        locations."/" = { root = "/sites/zumserve.com/src/public"; };
        listen = [{
          addr = "10.0.40.101";
          port = 443;
          ssl = true;
        }];
      };

      "zumserve.com80" = {
        serverName = "zumserve.com";
        serverAliases = [ "*.zumserve.com" ];
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/challenges-zumserve";
          extraConfig = ''
            auth_basic off;
          '';
        };
        #locations."/" = { return = "301 https://$host$request_uri"; };
        locations."/" = { root = "/sites/zumserve.com/src/public"; };

        listen = [{
          addr = "10.0.40.101";
          port = 80;
        }];
      };
    };
  };
}
