{ config, pkgs, ... }:

{
  xdg.configFile."rofi/powermenu.rasi".text = ''
    * {
      bg: #${config.lib.stylix.colors.base00};
      bg-alt: #${config.lib.stylix.colors.base01};
      fg: #${config.lib.stylix.colors.base05};
      fg-alt: #${config.lib.stylix.colors.base04};
      primary: #${config.lib.stylix.colors.base0D};
      urgent: #${config.lib.stylix.colors.base08};

      background-color: transparent;
      text-color: @fg;
    }

    window {
      transparency: "real";
      location: center;
      anchor: center;
      fullscreen: false;
      width: 600px;
      x-offset: 0px;
      y-offset: 0px;

      enabled: true;
      margin: 0px;
      padding: 0px;
      border: 2px solid;
      border-radius: 12px;
      border-color: @primary;
      cursor: "default";
      background-color: @bg;
    }

    mainbox {
      enabled: true;
      spacing: 15px;
      margin: 0px;
      padding: 30px;
      border: 0px solid;
      border-radius: 0px;
      border-color: @primary;
      background-color: transparent;
      children: [ "inputbar", "listview" ];
    }

    inputbar {
      enabled: true;
      spacing: 15px;
      margin: 0px;
      padding: 0px;
      border: 0px;
      border-radius: 0px;
      border-color: @primary;
      background-color: transparent;
      text-color: @fg;
      children: [ "prompt" ];
    }

    prompt {
      enabled: true;
      padding: 10px;
      border-radius: 8px;
      background-color: @primary;
      text-color: @bg;
      font: "JetBrains Mono Nerd Font Bold 12";
    }

    listview {
      enabled: true;
      columns: 5;
      lines: 1;
      cycle: true;
      dynamic: true;
      scrollbar: false;
      layout: vertical;
      reverse: false;
      fixed-height: true;
      fixed-columns: true;
      spacing: 15px;
      margin: 0px;
      padding: 0px;
      border: 0px solid;
      border-radius: 0px;
      border-color: @primary;
      background-color: transparent;
      text-color: @fg;
      cursor: "default";
    }

    element {
      enabled: true;
      spacing: 0px;
      margin: 0px;
      padding: 20px 10px;
      border: 0px solid;
      border-radius: 8px;
      border-color: @primary;
      background-color: @bg-alt;
      text-color: @fg;
      cursor: pointer;
    }

    element-text {
      font: "JetBrains Mono Nerd Font 24";
      background-color: transparent;
      text-color: inherit;
      cursor: inherit;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    element normal.normal {
      background-color: @bg-alt;
      text-color: @fg;
    }

    element selected.normal {
      background-color: @primary;
      text-color: @bg;
    }

    element alternate.normal {
      background-color: @bg-alt;
      text-color: @fg;
    }
  '';

  home.packages = [
    (pkgs.writeShellScriptBin "nixos-powermenu" ''
      # Options
      shutdown=""
      reboot=""
      lock=""
      suspend="󰒲"
      logout="󰍃"

      # Prompt
      prompt="Hello, $USER"

      # Pass variables to rofi dmenu
      chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$lock" "$suspend" "$logout" | rofi -dmenu -theme ~/.config/rofi/powermenu.rasi -p "$prompt")

      case "$chosen" in
        "$shutdown")
          systemctl poweroff
          ;;
        "$reboot")
          systemctl reboot
          ;;
        "$lock")
          hyprlock
          ;;
        "$suspend")
          systemctl suspend
          ;;
        "$logout")
          hyprctl dispatch exit
          ;;
      esac
    '')
  ];
}
