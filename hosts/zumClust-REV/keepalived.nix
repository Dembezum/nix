{ pkgs, ... }: {

  services.keepalived = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      vrrp_instance VI_1 {
        state MASTER
        interface enX0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
          auth_type PASS
          auth_pass 1234
        }
        virtual_ipaddress {
          10.0.40.201
        }
      }
    '';
  };

  environment.systemPackages = with pkgs; [ keepalived ];
}
