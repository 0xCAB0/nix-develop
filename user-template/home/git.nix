# File: ~/.config/nixos/home/git.nix

{ config, pkgs, ... }:

{
  # Your personal Git configuration
  programs.git = {
    userName = "Your Name";
    userEmail = "your-email@example.com";
  };
}
