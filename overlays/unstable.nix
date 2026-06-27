inputs: final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    # Match the architecture of the system being built
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
}
