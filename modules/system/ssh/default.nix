# SSH setup
{
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
    ports = [ 22 ];
  };
}
