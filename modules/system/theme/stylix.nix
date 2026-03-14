{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.image = ../../home/hyprland/wallpapers/background.jpg;
  stylix.polarity = "dark";
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono Nerd Font";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.droid-sans-mono;
      name = "Droid Sans Mono Nerd Font";
    };
    serif = {
      package = pkgs.nerd-fonts.droid-sans-mono;
      name = "Droid Sans Mono Nerd Font";
    };
  };
}
