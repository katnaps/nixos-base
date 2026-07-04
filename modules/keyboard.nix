{
  # System Udev Rules
  # MCHOSE Ace60 Pro (Allows user-space access to the keyboard/mouse HID raw device)
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2103", MODE="0666", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2103", MODE="0666", TAG+="uaccess"
  '';
}
