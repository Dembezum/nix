{ inputs, config, pkgs, userSettings, ... }:
# Nixdesk
{
  # -- IMPORTS --
  imports = [
    ../../modules/user/gtk
    ../../modules/user/foot
    ../../modules/user/zsh
    ../../modules/user/tmux
    ../../modules/user/kitty
    #      ../../modules/modules/neovim
    #      ../../modules/modules/shells
    ../../modules/user/hyprland
    ../../modules/user/desktop
  ];

  # -- USER SETTINGS --
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";
  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # -- DEFAULT PACKAGES --
  home.packages = with pkgs; [
    headsetcontrol
    easyeffects
    inkscape
    drawio
    lazygit
    jq
    #sops
    #darktable
    rawtherapee
    imagemagick
    nautilus
    ventoy
    inputs.nixvim-flake.packages.${system}.default
  ];

  # -- VARIABLES --
  home.sessionVariables = {
    TERM = userSettings.term;
    TERMINAL = userSettings.terminal;
    BROWSER = userSettings.browser;
    EDITOR = userSettings.editor;
    VIDEO = userSettings.video;
    IMAGE = userSettings.image;
  };

  # -- XDG USER CONFIGURATION --
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = { XDG_GAME_DIR = "${config.home.homeDirectory}/Games"; };
  };
  home.stateVersion = userSettings.homestate;
}
