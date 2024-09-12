{ userSettings, pkgs, ... }:

{
  # -- IMPORTS --
  imports = [
    ../../modules/user/tmux
    ../../modules/user/shell

  ];

  # -- USER SETTINGS --
  home = {
    inherit (userSettings) homestate editor term;
    homeDirectory = "/home/" + userSettings.username;

  };
  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # -- HOME PACKAGES --
  #  home.packages = with pkgs;
  #    [
  #
  #    ];

  # -- VARIABLES --
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
  };

  # -- XDG CONFIGURATION --
  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {

    };
  };
  home.stateVersion = userSettings.homestate;
}
