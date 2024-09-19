{ pkgs, ... }:

let
  keepalivedConfig = ''
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
        10.0.41.100
      }
    }
  '';
in {

  environment.systemPackages = with pkgs; [ keepalived ];

  environment.etc."keepalived/keepalived.conf".text = keepalivedConfig;
}
