{ config, pkgs, ... }:

{
  home.username = "katnaps";
  home.homeDirectory = "/home/katnaps";

  programs.git.enable = true;

  services.udiskie.enable = true;

  home.stateVersion = "26.05";
}
