{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.awesomewm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.awesomewm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        awesome = super.awesome.override { lua = super.luajit; };
      })
    ];

    environment.systemPackages = with pkgs; [
      luajit
      my.fennel
    ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
        #  lightdm.greeters.mini.enable = true;
        };
        windowManager.awesome.enable = true;
      };
    };

    home.configFile = {
      "awesome" = { source = "${configDir}/awesome"; recursive = true; };
      "awesome/rc.lua".text = ''
        -- File was auto-generated by nix. Do not touch!

        -- Load system fennel
        package.path = package.path .. ";${pkgs.my.fennel}/?.lua"
        local fennel = require("fennel")
        debug.traceback = fennel.traceback

        -- Then load our awesomewm config
        fennel.path = fennel.path .. ";.config/awesome/?.fnl"
        table.insert(package.loaders or package.searchers, fennel.makeSearcher({
            correlate    = true,
            useMetadata  = true
        }))
        require("init")
      '';
    };
  };
}
