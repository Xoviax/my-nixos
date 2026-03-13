{ config, pkgs, inputs, ... }:

{
  home.username = "xoviax";
  home.homeDirectory = "/home/xoviax";

  # Install your personal apps here!
  home.packages = with pkgs; [
    fastfetch
    btop
    vscode
    inputs.antigravity-nix.packages.x86_64-linux.default

    mpv
    vlc
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Rayn Yorobe";
      user.email = "raynyorobe@gmail.com";
    };
  };

  imports = [
    ./modules/home/hyprland/default.nix
    ./modules/home/theme.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}