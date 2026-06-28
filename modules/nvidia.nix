{ config, ... }:

{
  # NVIDIA Driver
  hardware.nvidia = {
    enable = true;
    # Use legacy 580 driver for GTX 10xx series
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    # Important for Hyprland / Wayland
    modesetting.enable = true;

    # Enable the nvidia-settings GUI tool
    nvidiaSettings = true;

    # Power management (disable by default, enable on laptops if needed)
    powerManagement.enable = false;

    # Open kernel modules (usually false for legacy drivers)
    open = false;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      sync.enable = false;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Required for proper NVIDIA behavior on modern NixOS
  services.xserver.videoDrivers = [ "nvidia" ];
}
