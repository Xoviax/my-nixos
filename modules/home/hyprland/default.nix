{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  # Also install Hyprland ecosystem dependencies like Kitty, Rofi, Waybar
  home.packages = with pkgs; [
    kitty
    rofi
    waybar
    swww # For wallpaper
    swaynotificationcenter # For notifications
    brightnessctl # For brightness controls
    playerctl # For media controls
    hyprshot # For screenshots
  ];
}
