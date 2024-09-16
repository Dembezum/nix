{ systemSettings, ... }:
# Librenms
{
  services.librenms = {
    enable = true;
    user = "librenms";
    group = "librenms";
    hostname = "${systemSettings.hostname}.zumserve.com";
    dataDir = "/var/lib/librenms";
    logDir = "/var/log/librenms";

    database = {
      createLocally = true;
      host = "localhost";
      database = "librenms";
      username = "librenms";
      passwordFile = "/run/secret/librenms-db-password";
    };

    settings = {
      base_url = "/";
      top_devices = true;
      top_ports = false;
    };
  };
}
