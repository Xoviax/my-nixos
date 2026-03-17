{ config, pkgs, inputs, system, ... }:

{
  home.username = "xoviax";
  home.homeDirectory = "/home/xoviax";
  
  home.packages = with pkgs; [
    btop
    fastfetch
    vscode
    inputs.antigravity-nix.packages.${system}.default

    weylus

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
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  # xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  programs.home-manager.enable = true;

  qt.enable = true;
  gtk.enable = true;

  home.stateVersion = "25.11";
}