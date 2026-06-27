{
  hardware.bluetooth.enable = true;

  # Kills the internal Intel card completely (Wi-Fi + BT)
  boot.blacklistedKernelModules = [ "iwlwifi" ];

  # Keep your external USB Bluetooth dongles working
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa", ATTR{authorized}="0"
  '';
}
