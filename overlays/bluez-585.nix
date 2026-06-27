final: prev: {
  bluez = prev.bluez.overrideAttrs (old: {
    version = "5.85";
    src = prev.fetchurl {
      url = "mirror://kernel/linux/bluetooth/bluez-5.85.tar.xz";
      sha256 = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
    };

    # Remove patches that don't apply to version 5.85
    patches = [ ];
  });
}
