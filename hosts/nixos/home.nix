{ inputs, userSettings, pkgs, ... }:

{
  # -- IMPORTS --
  imports = [
    ../../modules/user/tmux
    ../../modules/user/zsh

  ];

  # -- USER SETTINGS --
  home = {
    inherit (userSettings) username;
    homeDirectory = "/home/" + userSettings.username;

  };
  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
    };
  };

  # -- DEFAULT PACKAGES --
  home.packages = with pkgs;
    [
      inputs.nixvim-flake.packages.${system}.default

    ];

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
