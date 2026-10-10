{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      bar.default = {
        position = "top";
        start = [
          "launcher"
          "workspaces"
          "active_window"
        ];
        center = [
          "clock"
          "media"
        ];
        end = [
          "sysmon"
          "volume"
          "brightness"
          "network"
          "bluetooth"
          "battery"
          "notifications"
          "control-center"
        ];
      };
    };
  };
}
