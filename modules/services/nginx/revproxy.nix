{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nginx openssl ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "dembezuuma@gmail.com";
    certs = {
      "reverseproxy.zumserve.com" = {
        webroot = "/var/lib/acme/challenges-reverseproxy";
        email = "dembezuuma@gmail.com";
        group = "nginx";
        domain = "reverseproxy.zumserve.com";
        extraDomainNames = [ "www.reverseproxy.zumserve.com" ];
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    logError = "stderr info";
    virtualHosts = {
      "reverseproxy.zumserve.com" = {
        addSSL = true;
        useACMEHost = "reverseproxy.zumserve.com";
        serverAliases = [ "*.reverseproxy.zumserve.com" ];
        acmeRoot = "/var/lib/acme/challenges-reverseproxy";
        locations."/" = {
          proxyPass = "http://10.0.40.101:80";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            try_files $uri $uri/ =404;

            # Limit request methods
            if ($request_method !~ ^(GET|POST|HEAD)$ ) {
              return 444;
            }

            # Hide Nginx version
            server_tokens off;
          '';
        };
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];
      };

      "reverseproxy.zumserve.com80" = {
        serverName = "reverseproxy.zumserve.com";
        serverAliases = [ "*.reverseproxy.zumserve.com" ];
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/challenges-reverseproxy";
          extraConfig = ''
            auth_basic off;
            try_files $uri $uri/ =404;
            server_tokens off;


            try_files $uri $uri/ =404;

            # Limit request methods
            if ($request_method !~ ^(GET|POST|HEAD)$ ) {
              return 444;
            }

            # Hide Nginx version
            server_tokens off;
          '';
        };
        locations."/" = { return = "301 https://$host$request_uri"; };
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];
      };
    };
  };
}
