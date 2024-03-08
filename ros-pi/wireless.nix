{
  networking.wireless = {
    interfaces = [ "wlan0" ];
    enable = true;
    networks = {
      dte.psk = "dtexgenki";
    };
  };
}
