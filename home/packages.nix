# File: ~/.config/nixos/home/packages.nix

{ config, pkgs, ... }:

{
  # Your personal packages not included in the team config
  home.packages = with pkgs; [
    sl # The fun steam locomotive
  ];
}
