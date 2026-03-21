{ config, 
  pkgs, 
  inputs, 
  system, 
  lib, 
  ... 
}:

{
  home.username = "xoviax";
  home.homeDirectory = "/home/xoviax";
  
  home.packages = with pkgs; [
    btop
    fastfetch
    vscode
    inputs.antigravity-nix.packages.${system}.default

    weylus

    vesktop

    wiremix
    bluetui

    mpv
    vlc

    nautilus
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Rayn Yorobe";
      user.email = "raynyorobe@gmail.com";
    };
  };

  home.shellAliases = {
    ll = "ls -lh";
    flakerebuild = "sudo nixos-rebuild switch --flake /home/xoviax/nixos-config#zafkiel";
    port-mon-on = "hyprctl output create headless";
    port-mon-off = "hyprctl output remove HEADLESS-2";
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh My Zsh framework
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = ""; 
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  imports = [
    ./hyprland/default.nix
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  stylix.targets.waybar.enable = false;
  xdg.configFile."waybar/style.css".text = lib.mkForce ''
    @define-color base00 #${config.lib.stylix.colors.base00};
    @define-color base01 #${config.lib.stylix.colors.base01};
    @define-color base02 #${config.lib.stylix.colors.base02};
    @define-color base03 #${config.lib.stylix.colors.base03};
    @define-color base04 #${config.lib.stylix.colors.base04};
    @define-color base05 #${config.lib.stylix.colors.base05};
    @define-color base06 #${config.lib.stylix.colors.base06};
    @define-color base07 #${config.lib.stylix.colors.base07};
    @define-color base08 #${config.lib.stylix.colors.base08};
    @define-color base09 #${config.lib.stylix.colors.base09};
    @define-color base0A #${config.lib.stylix.colors.base0A};
    @define-color base0B #${config.lib.stylix.colors.base0B};
    @define-color base0C #${config.lib.stylix.colors.base0C};
    @define-color base0D #${config.lib.stylix.colors.base0D};
    @define-color base0E #${config.lib.stylix.colors.base0E};
    @define-color base0F #${config.lib.stylix.colors.base0F};

    ${builtins.readFile ./waybar/style.css}
  '';

  programs.home-manager.enable = true;

  qt.enable = true;
  gtk.enable = true;

  home.stateVersion = "25.11";
}