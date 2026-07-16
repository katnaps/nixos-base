{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;

    # Isolate your custom bluez version right here
    package = pkgs.bluez.overrideAttrs (
      finalAttrs: _prev: {
        version = "5.85";

        src = pkgs.fetchurl {
          urls = [
            "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
            "https://www.kernel.org/pub/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
          ];
          hash = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
        };

        patches = [ ];
      }
    );
  };

  # Kills the internal Intel card completely (Wi-Fi + BT)
  boot.blacklistedKernelModules = [ "iwlwifi" ];

  # Keep your external USB Bluetooth dongles working
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa", ATTR{authorized}="0"
  '';
}
