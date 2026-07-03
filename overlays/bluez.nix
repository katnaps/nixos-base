final: prev: {
  bluez = prev.bluez.overrideAttrs (
    finalAttrs: _prev: {
      version = "5.85";

      # If kernel url is down, comment this block and uncomment fetchFromGitHub block
      src = final.fetchurl {
        urls = [
          "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
          "https://www.kernel.org/pub/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz"
        ];
        hash = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
      };

      # src = final.fetchFromGitHub {
      #   owner = "bluez";
      #   repo = "bluez";
      #   rev = "5.85";
      #   hash = "sha256-MT0FMo/ENKq7XR3wBHKe6Xzx+riGUM6pNqiJrS6NH64=";
      # };

      # Use autoreconfHook only when using fetchFromGitHub
      # nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.autoreconfHook ];

      # Keeping it lightweight and fast by removing autoreconfHook
      # and clearing older patches cleanly
      patches = [ ];
    }
  );
}
