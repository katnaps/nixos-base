inputs: final: prev: {
  stable = import inputs.nixpkgs-stable {
    # Match the architecture of the system being built
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
}
