{
  networking.firewall.allowedTCPPorts = [ 80 90 91 8443 443 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "dembezuuma@gmail.com";
    certs = {
      "zumserve.com" = {
        webroot = "/sites/zumserve.com/src/public";
        email = "dembezuuma@gmail.com";
        domain = "www.zumserve.com";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "dev.zumserve.com" = {
        serverName = "dev.zumserve.com";
        root = "/sites/dev.zumserve.com/src/public";
        listen = [{
          port = 91;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          extraConfig = ''
            index index.html;
          '';
        };
      };
      "zumserve.com" = {
        serverName = "zumserve.com";
        root = "/sites/zumserve.com/src/public";
        listen = [{
          port = 443;
          addr = "0.0.0.0";
        }];

        locations."/.well-known/acme-challenge/" = {
          root = "/sites/zumserve.com/src/public";
        };

        locations."/" = {
          root = "/sites/zumserve.com/src/public";
          proxyPass = "http://127.0.0.1:90";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            index index.html;
          '';
        };
      };
    };
  };
}
