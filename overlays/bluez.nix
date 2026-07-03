final: prev: {
  bluez = prev.bluez.overrideAttrs (
    finalAttrs: _prev: {
      version = "5.85";

      src = final.fetchurl {
        urls = [
          "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
          "https://www.kernel.org/pub/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
        ];
        hash = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
      };

      patches = [ ];
    }
  );
}
