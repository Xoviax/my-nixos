{ config, pkgs, inputs, ... }:

{
  home.username = "xoviax";
  home.homeDirectory = "/home/xoviax";
  
  home.packages = with pkgs; [
    btop
    fastfetch
    vscode
    inputs.antigravity-nix.packages.x86_64-linux.default

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

  programs.home-manager.enable = true;

  

  qt.enable = true;
  gtk.enable = true;

  home.stateVersion = "25.11";
}