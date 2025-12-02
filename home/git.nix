# File: ~/.config/nixos/home/git.nix

{ config, pkgs, ... }:

{
  # Your personal Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Your Name";
        email = "your-email@example.com";
      };
    };
  };
}
