final: prev: {
  bluez = prev.bluez.overrideAttrs (old: {
    version = "5.85";
    src = prev.fetchFromGitHub {
      owner = "bluez";
      repo = "bluez";
      rev = "5.85";
      hash = "sha256-v9OpRed1eVxNdPeo4X2Jh1qKfyFcoWfzmguQbRcJd78=";
    };

    # Remove patches that don't apply
    patches = [ ];
  });
}
