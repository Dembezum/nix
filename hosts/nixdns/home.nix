{ pkgs, userSettings, ... }:

{
  # -- IMPORTS --
  imports = [
    ../../modules/user/neovim
    ../../modules/user/tmux
    ../../modules/user/shells
  ];

  # -- USER SETTINGS --
  home = {
    inherit (userSettings) username editor term browser;
    home.homeDirectory = "/home/" + userSettings.username;
    # -- VARIABLES --
    sessionVariables = {
      EDITOR = userSettings.editor;
      TERM = userSettings.term;
      BROWSER = userSettings.browser;
    };
    # -- PACKAGES --
    packages = with pkgs; [ lazygit ];
  };

  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # -- XDG CONFIGURATION --
  xdg.enable = true;
  xdg.userDirs = { extraConfig = { }; };
  home.stateVersion = userSettings.homestate;
}
