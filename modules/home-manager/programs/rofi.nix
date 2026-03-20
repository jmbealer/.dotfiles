{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    # terminal = "rofi-sensible-terminal"; # Commented out to avoid conflicts if defined elsewhere
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      # General setting
      modi = "drun,run,filebrowser,window";
      case-sensitive = false;
      cycle = true;
      filter = "";
      scroll-method = 0;
      normalize-match = true;
      show-icons = true;
      icon-theme = "Papirus";
      steal-focus = false;

      # Matching setting
      matching = "normal";
      tokenize = true;

      # SSH settings
      ssh-client = "ssh";
      ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
      parse-hosts = true;
      parse-known-hosts = true;

      # Drun settings
      drun-categories = "";
      # drun-match-fields = "name,generic,exec,categories,keywords";
      drun-match-fields = "name,generic,categories,keywords";
      drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
      drun-show-actions = false;
      drun-url-launcher = "xdg-open";
      # drun-use-desktop-cache = false;
      drun-use-desktop-cache = true;
      # drun-reload-desktop-cache = false;
      drun-reload-desktop-cache = true;
      
      # The following blocks are commented out because they conflict with restricted module options 
      # or default settings in the current environment. 
      # Most of these settings (like parse-user=true) are defaults anyway.
      
      # drun = {
      #   parse-user = true;
      #   parse-system = true;
      # };

      # Run settings
      run-command = "{cmd}";
      run-list-command = "";
      run-shell-command = "{terminal} -e {cmd}";

      # Fallback Icon
      # "run,drun" = {
      #   fallback-icon = "application-x-addon";
      # };

      # Window switcher settings
      window-match-fields = "title,class,role,name,desktop";
      window-command = "wmctrl -i -R {window}";
      window-format = "{w} - {c} - {t:0}";
      window-thumbnail = false;

      # History and Sorting
      disable-history = false;
      # sorting-method = "normal";
      sorting-method = "fzf";
      max-history-size = 25;

      # Display setting
      display-window = "Windows";
      display-windowcd = "Window CD";
      display-run = "Run";
      display-ssh = "SSH";
      display-drun = "Apps";
      display-combi = "Combi";
      display-keys = "Keys";
      display-filebrowser = "Files";

      # Misc setting
      # sort = false;
      sort = true;
      threads = 0;
      click-to-exit = true;
      sidebar-mode = true;

      # File browser settings
      # filebrowser = {
      #   directories-first = true;
      #   sorting-method = "name";
      # };

      # Other settings
      # timeout = {
      #   action = "kb-cancel";
      #   delay = 0;
      # };
    };
  };
}