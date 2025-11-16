# File: ~/.config/nixos/home.nix

{ config, pkgs, ... }:

{
  # --- Basic Home Manager Settings ---
  # These apply to your user
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "25.05"; # Match system state version

  # --- Import Your Personal Tool Configs ---
  # This list pulls in all the separate files
  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/packages.nix
  ];
  
  # You can keep `programs.home-manager.enable = true;` here
  # if you had it, but it's often handled by the NixOS module.
}
