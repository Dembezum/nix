{ config, pkgs, ... }:

let
  bindConfig = ''
    options {
      directory "/var/bind";
      listen-on port 53 { 10.0.20.10; };  # DNS server IP
      allow-query { any; };
      recursion yes;
      dnssec-validation no;  # Adjust as needed for security preferences
      empty-zones-enable no;
    };

    zone "mgmt.zumserve.com" {
      type master;
      file "/var/bind/db.mgmt.zumserve.com";
    };

    zone "server.zumserve.com" {
      type master;
      file "/var/bind/db.server.zumserve.com";
    };

    zone "access.zumserve.com" {
      type master;
      file "/var/bind/db.access.zumserve.com";
    };

    zone "vmcont.zumserve.com" {
      type master;
      file "/var/bind/db.vmcont.zumserve.com";
    };

    zone "10.0.10.in-addr.arpa" {
      type master;
      file "/var/bind/db.10.0.10";
    };

    zone "10.0.20.in-addr.arpa" {
      type master;
      file "/var/bind/db.10.0.20";
    };

    zone "10.0.30.in-addr.arpa" {
      type master;
      file "/var/bind/db.10.0.30";
    };

    zone "10.0.40.in-addr.arpa" {
      type master;
      file "/var/bind/db.10.0.40";
    };
  '';

in {
  services.bind = {
    enable = true;
    configfile = bindconfig;
    extraconfig = ''
      include "/var/bind/zones.conf";
    '';
  };

  # creating zone files
  systemd.services.bind.prestart = ''
    mkdir -p /var/bind

    # management vlan zone file
    cat > /var/bind/db.mgmt.zumserve.com << eof
    $ttl 86400
    @   in  soa ns1.mgmt.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.mgmt.zumserve.com.
    ns1 in  a   10.0.20.10
    router in  a   10.0.10.1
    eof

    # server vlan zone file
    cat > /var/bind/db.server.zumserve.com << eof
    $ttl 86400
    @   in  soa ns1.server.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.server.zumserve.com.
    ns1 in  a   10.0.20.10
    server1 in  a   10.0.20.100
    eof

    # access vlan zone file
    cat > /var/bind/db.access.zumserve.com << eof
    $ttl 86400
    @   in  soa ns1.access.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.access.zumserve.com.
    ns1 in  a   10.0.20.10
    nixdesk in  a   10.0.30.10
    eof

    # vm/container vlan zone file
    cat > /var/bind/db.vmcont.zumserve.com << eof
    $ttl 86400
    @   in  soa ns1.vmcont.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.vmcont.zumserve.com.
    ns1 in  a   10.0.20.10
    vm1 in  a   10.0.40.35
    eof

    # reverse zone files for ptr records
    cat > /var/bind/db.10.0.10 << eof
    $ttl 86400
    @   in  soa ns1.mgmt.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.mgmt.zumserve.com.
    1   in  ptr router.mgmt.zumserve.com.
    eof

    cat > /var/bind/db.10.0.20 << eof
    $ttl 86400
    @   in  soa ns1.server.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.server.zumserve.com.
    10  in  ptr ns1.server.zumserve.com.
    100 in  ptr server1.server.zumserve.com.
    eof

    cat > /var/bind/db.10.0.30 << eof
    $ttl 86400
    @   in  soa ns1.access.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.access.zumserve.com.
    10  in  ptr device1.access.zumserve.com.
    eof

    cat > /var/bind/db.10.0.40 << eof
    $ttl 86400
    @   in  soa ns1.vmcont.zumserve.com. admin.zumserve.com. (
    2024091701  ; serial
    3600        ; refresh
    1800        ; retry
    1209600     ; expire
    86400       ; minimum ttl
    )
    in  ns  ns1.vmcont.zumserve.com.
    50  in  ptr vm1.vmcont.zumserve.com.
    eof
  '';
}
