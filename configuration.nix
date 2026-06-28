{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Set linux kernel version
  boot.kernelPackages = pkgs.linuxPackages;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
    persistent = true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "nixos-fruit"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  nixpkgs.config.allowUnfree = true;

  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.coconut = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.steam.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    usbutils
    unzip
    alsa-utils
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    roboto
    roboto-mono
    font-awesome
    liberation_ttf
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List services that you want to enable:
  services.upower.enable = true;
  services.udisks2.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25; # Uses up to 4GB of your 16GB RAM for compressed, fast swap
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GB emergency safety net on your SSD
      options = [ "discard" ]; # Enables continuous TRIM to protect NVMe performance
      priority = 100; # Explicitly lower than zram (32767), so zram is used first
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100; # Balanced: utilizes zram cleanly without causing game micro-stutters
  };

  system.stateVersion = "26.05";
}
