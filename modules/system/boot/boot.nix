{ pkgs, ... }: {
  boot.loader = {
    systemd-boot.enable = false;

    limine = {
      enable = true;
      efiSupport = true;

      style = {
        # wallpapers = [ ./boot-bg.png ];
        wallpaperStyle = "stretched";
      };
  
      extraConfig = ''
        term_background: 80000000
        term_margin: 50
      '';
    };

    efi.canTouchEfiVariables = true;
  };
}