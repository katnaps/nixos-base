{ config, pkgs, ... }:

{
  home.username = "coconut";
  home.homeDirectory = "/home/coconut";

  programs.git.enable = true;

  services.udiskie.enable = true;

  home.stateVersion = "26.05";
}
