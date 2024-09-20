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
        webroot =
          "/sites/zumserve.com/src/public"; # Ensure this path exists and is writable
        email = "dembezuuma@gmail.com";
        domain = "www.zumserve.com";
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
          port = 8080;
          addr = "0.0.0.0";
        }];

        locations."/.well-known/acme-challenge/" = {
          root =
            "/sites/zumserve.com/src/public"; # Ensure this path exists and is writable
        };

        locations."/" = {
          root = "/sites/zumserve.com/src/public";
          proxyPass = "http://127.0.0.1:8080";
          index = "index.html";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };
    };
  };
}
