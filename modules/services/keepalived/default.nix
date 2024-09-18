{
  services.keepalived = {
    openFirewall = true;
    vrrpInstances.test = {
      interface = "enX0";
      state = "MASTER";
      priority = 50;
      virtualIps = [{ addr = "10.0.41.100"; }];
      virtualRouterId = 1;
    };

  };
}
