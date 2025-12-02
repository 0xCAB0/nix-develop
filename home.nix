{ config, pkgs, ... }:

{
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "25.05";

  # --- Import Your Personal Tool Configs ---
  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/packages.nix
  ];
  
}
