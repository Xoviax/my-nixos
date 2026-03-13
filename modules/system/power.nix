{ pkgs, lib, ... }:

{
  # Disable the GNOME/standard power daemon to avoid conflicts with TLP
  services.power-profiles-daemon.enable = false;

  # Enable TLP for advanced ThinkPad battery management
  services.tlp = {
    enable = false;
    settings = {
      # Battery charge thresholds to extend lifespan
      # Stop charging at 80% to prevent wear
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 80;

      # Performance scaling based on power source
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Boost frequencies
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
    };
  };

  # Enable firmware updates for the T480's controllers
  services.fwupd.enable = true;
}