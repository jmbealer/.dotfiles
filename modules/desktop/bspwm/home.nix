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
            # "focused" = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X"];
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

            # focused_border_color = "#65b2ff";
            # normal_border_color = "#3b4252";
            focused_border_color = "#928374";
            normal_border_color = "#282828";

            # -- MOUSE -- #
            # pointer_modifier = "mod1";
            # pointer_action1 = "move";
            # pointer_action2 = "resize_side";
          };
          rules = {
            "Emacs" = { state = "tiled"; };
            "Zathura" = {
              state = "tiled";
              follow = true;
              focus = true;
            };
            "mpv" = {
              state = "floating";
              sticky = true;
              follow = false;
              focus = true;
            };
            "*:Toolkit:Picture-in-Picture" = {
              state = "floating";
              sticky = true;
              follow = false;
              focus = true;
            };
          };
          extraConfig = ''
            bspc monitor DP-2 -d 1 2 3 4 5 6 7 8 9 10
            bspc monitor DP-3 -d 1 2 3 4 5 6 7 8 9 10
            # bspc monitor -d 1 2 3 4 5 6 7 8 9 10
            # bspc monitor -d I II III IV V VI VII VIII IX X

            # feh --bg-tile $HOME/.config/wall
            feh --bg-scale $HOME/.wallpapers/wallhaven-qd7xkr.png

            unclutter &
            xbanish &
            xset r rate 200 50 &

            launch_polybar.sh

            # killall -q polybar &
            # while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done
            # polybar main & #2>~/log &
            # polybar sec & #2>~/log &
          '';
          # startupPrograms = [
            # "feh --bg-tile $HOME/.wallpapers/wallhaven-83z85y.jpg"

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
