{ pkgs, ... }: {
  services.mediawiki = {
    enable = true;
    name = "ZumWiki";
    httpd.virtualHost = {
      hostName = "nixwiki.zumserve.local";
      adminAddr = "wiki@admin.zumserve.local";
    };

    # Administrator account username is admin.
    passwordFile = pkgs.writeText "password" "mediawikipass";
    extraConfig = ''
      # Disable anonymous editing
            $wgGroupPermissions['*']['edit'] = false;
    '';

    extensions = { VisualEditor = null; };
  };
}
