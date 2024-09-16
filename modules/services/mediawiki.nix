# MediaWiki

{ pkgs, ... }: {

  services.mediawiki = {
    enable = true;
    name = "zumserveWiki";
    httpd.virtualHost = {
      hostName = "nixwiki.zumserve.com";
      adminAddr = "nixwiki@admin.zumserve.com";
    };

    # Single use password 
    passwordFile = pkgs.writeText "password" "admin";
    extraConfig = ''
      # Disable anonymous editing
            $wgGroupPermissions['*']['edit'] = false;
    '';

    extensions = { VisualEditor = null; };
  };
}
