{
  inputs,
  config,
  pkgs,
  ...
}:

let
  pinnedBluezBase = inputs.nixpkgs-bluez.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bluez;

  customBluez585 = import ../pkgs/bluez-585.nix {
    inherit (pkgs) fetchurl;
    bluez = pinnedBluezBase;
  };
in

{
  hardware.bluetooth = {
    enable = true;
    # Pin ONLY the bluetooth system service to 5.85
    package = customBluez585;
  };
  # Kills the internal Intel card completely (Wi-Fi + BT)
  boot.blacklistedKernelModules = [ "iwlwifi" ];

  # Keep your external USB Bluetooth dongles working
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa", ATTR{authorized}="0"
  '';
}
