{ config, pkgs, inputs, ... }:

{
  home.username = "xoviax";
  home.homeDirectory = "/home/xoviax";
  
  home.packages = with pkgs; [
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

  imports = [
    ./hyprland/default.nix
  ];

  programs.home-manager.enable = true;

  stylix.targets.btop.colors.enable = true;


  qt.enable = true;
  gtk.enable = true;

  home.stateVersion = "25.11";
}