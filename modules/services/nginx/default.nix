{ systemSettings, ... }:

let
  imports = if systemSettings.host == "zumClust-MAS" then
    [ ./webserver.nix ]
  else if systemSettings.host == "zumClust-SLA1" then
    [ ./webserver.nix ]
  else if systemSettings.host == "zumClust-SLA2" then
    [ ./webserver.nix ]
  else if systemSettings.host == "zumClust-REV" then
    [ ./revproxy.nix ]
  else
    [ ];
in { imports = imports; }
