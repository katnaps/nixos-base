final: prev: {
  bluez = prev.bluez.overrideAttrs (old: rec {
    version = "5.85";

    src = prev.fetchurl {
      urls = [
        "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz"
        "https://www.kernel.org/pub/linux/bluetooth/bluez-${version}.tar.xz"
      ];
      hash = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
    };

    patches = [ ];
  });
}
