{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      background_opacity = "0.80";
      disable_ligatures = "never";
      enable_audio_bell = "no";
      sync_to_monitor = "no";
      cursor_shape = "block";
      cursor_blink_interval = "0.2";
      url_style = "curly";
      shell_integration = "disabled";
      remember_window_size = "no";
      window_padding_width = "20";
      confirm_os_window_close = "0";
      scrollbar_handle_opacity = "0";
      scrollbar_track_opacity = "0";
      scrollbar_track_hover_opacity = "0";
      cursor_trail = "3";
    };
  };

  home.packages = with pkgs; [
    rofi
    swaynotificationcenter # For notifications
    brightnessctl # For brightness controls
    playerctl # For media controls
    hyprshot # For screenshots
  ];
}
