{ config, lib, pkgs, protocol, ... }:

{ 
  config = lib.mkIf ( protocol == "X" ) {
    xsession = {
      enable = true;
      windowManager = {
        bspwm = {
          enable = true;
          # monitors = { 
            # DP-2 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ]; 
            # "focused" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ]; 
            # DP-2 = [ "1" "2" "3" "4" "5" ]; 
            # DP-3 = [ "1" "2" "3" "4" "5" ]; 
          # };
          settings = {
            # -- THEME -- #
            border_width = 2;
            window_gap = 0;
            # top_padding = 20;
            # bottom_padding = 0;

            gapless_monocle = false;
            borderless_monocle = true;
            split_ratio = 0.5;

            focused_border_color = "#65b2ff";
            normal_border_color = "#3b4252";

            # -- MOUSE -- #
            pointer_modifier = "mod1";
            pointer_action1 = "move";
            pointer_action2 = "resize_side";
          };
          rules = {
            "Emacs" = { state = "tiled"; };
          };
          extraConfig = ''
            bspc monitor -d 1 2 3 4 5

            feh --bg-tile $HOME/.config/wall

            unclutter &
            xbanish &
            xset r rate 200 50 &

            killall -q polybar &
            while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done
            polybar main & #2>~/log &
          '';
          # startupPrograms = [
            # "feh --bg-tile $HOME/.config/wall"

            # "sxhkd"

            # "unclutter"
            # "xbanish"
            # "xset r rate 200 50"

            # "killall -q polybar"
            # "while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done"
            # "polybar main & #2>~/log"
            # "$HOME/.config/polybar/launch.sh"
            # Terminate already running polybar instances
            # "polybar -q -r top"
          # ];

        };
      };
    };
  };







  # monitors = { HDMI-0 = [ "" "" "" "" "" "" "" "" "" "" ]; };


  # startupPrograms = [
    # "feh --bg-fill $HOME/.config/bspwm-bak/FusionA1.png"
    # "sxhkd"

    # "$HOME/.config/polybar/launch.sh"
    # Terminate already running polybar instances
    # "killall -q polybar"
    # "polybar -q -r top"
  # ];
# };

}
