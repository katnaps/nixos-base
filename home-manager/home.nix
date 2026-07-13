{ config, pkgs, ... }:

{
  home.username = "katnaps";
  home.homeDirectory = "/home/katnaps";

  home.packages = with pkgs; [
    # Wayland
    hyprpaper
    waybar
    rofi
    grim
    slurp
    wl-clipboard
    brightnessctl
    mesa-demos

    # Terminal & Shell Utilities
    foot
    kitty
    oh-my-posh
    fastfetch
    nvtopPackages.full
    bat
    unzip
    zip

    # Media & Viewers
    vlc
    mpv
    swayimg
    wiremix

    # Languages
    nixd
    nixfmt
    rustup
    nodejs
  ];

  programs = {
    zsh.enable = false;
    zoxide.enable = true;
    fd.enable = true;
    btop.enable = true;
    firefox.enable = true;
    brave.enable = true;
    keepassxc.enable = true;
    git.enable = true;

    fzf = {
      enable = true;
      # This tells fzf to use fd for searching files
      defaultCommand = "fd --type f --hidden --exclude .git";
      # This tells fzf to use fd when you press Ctrl+T
      fileWidget.command = "fd --type f --hidden --exclude .git";
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services.udiskie.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  home.stateVersion = "26.05";
}
