{ fetchurl, bluez }:

bluez.overrideAttrs (oldAttrs: rec {
  version = "5.85";
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
    sha256 = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
  };
})
