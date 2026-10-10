{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;

    # Shell integration (bash)
    shellIntegration = {
      enableBashIntegration = true;
      mode = "enabled";
    };

    settings = {
      # --- Mouse & Selection (Automatic Copy-on-Select) ---
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
      clear_selection_on_clipboard_loss = "yes";
      click_interval = "0.5";
      mouse_hide_wait = "2.0";

      # --- Paste Safeguards ---
      paste_actions = "quote-urls-at-prompt,confirm";

      # --- Cursor & Ligatures ---
      cursor_shape = "beam";
      cursor_blink_interval = "-1";
      cursor_stop_blinking_after = "15.0";
      disable_ligatures = "never";

      # --- Performance & Display (Wayland / Hyprland) ---
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";

      # --- Window Layout & Padding ---
      remember_window_size = "no";
      initial_window_width = 1000;
      initial_window_height = 650;
      window_padding_width = 8;
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";

      # Note: background_opacity is managed automatically by Stylix (0.95)

      # --- Scrollback ---
      scrollback_lines = 10000;
      scrollback_pager_history_size = 256;

      # --- URLs & Hyperlinks ---
      url_style = "curly";
      open_url_with = "default";
      detect_urls = "yes";
      underline_hyperlinks = "hover";

      # --- Tab Bar Styling (Powerline Slanted) ---
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_min_tabs = 2;
      tab_activity_symbol = " ● ";
    };

    keybindings = {
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      # Scrollback
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";

      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";

      # Font Sizing
      "ctrl+shift+plus" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
    };

    extraConfig = ''
      # Red Cursor (overriding base16 theme default)
      cursor #ff033e
      cursor_text_color background

      # Tab title formatting
      tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"
      active_tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"
    '';
  };
}
