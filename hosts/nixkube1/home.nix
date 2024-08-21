{ userSettings, pkgs, ... }:

{
  # -- IMPORTS --
  imports = [ ../../modules/user/tmux ];

  # -- USER SETTINGS --
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # -- DEFAULT PACKAGES --
  home.packages = with pkgs; [ ];

  # -- VARIABLES --
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  # -- XDG CONFIGURATION --
  xdg.enable = true;
  xdg.userDirs = { extraConfig = { }; };
  home.stateVersion = userSettings.homestate;
}
