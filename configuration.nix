# File: configuration.nix
# -------------------------
# This is the main system configuration. It's equivalent to
# what you'd find in /etc/nixos/configuration.nix on a
# normal NixOS machine.

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  users.users.eve.isNormalUser = true;
  home-manager.users.eve = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;
  
    home.stateVersion = "25.05";

    # --- NixOS-WSL Configuration ---
  wsl = {
    enable = true;
    defaultUser = "dev";
  };

  # Set your time zone
  time.timeZone = "Europe/Madrid"; # TODO: Set your own

  users.users.dev = {
    isNormalUser = true;
    description = "Development User";
    extraGroups = [ "wheel" "docker" ]; # 'wheel' for sudo
    shell = pkgs.zsh; # Set Zsh as the default shell
  };
  
  # Allow sudo access for 'wheel' group
  security.sudo.wheelNeedsPassword = false;
 
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  # Find packages on: https://search.nixos.org/packages
    # Base tools
    git
    neovim
    curl
    wget
    
    # Zsh/Shell tools from your script
    zsh
    bat 
    
    # Development software 
    nodejs-22_x
    jdk17
  ];

  # --- Docker Configuration ---
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      tls = false; # Overrides Zscaler
      debug = true;
      "insecure-registries" = [ "docker.io" ];
    };
  };

  # --- Zsh Configuration ---
  # Managed in zsh.nix
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };

  # --- Home Manager Configuration
  programs.home-manager = {
    enable = true;
  };
  
  # --- Systemd Services ---
  
  systemd.services."docker" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release version
  system.stateVersion = "25.05"; 
  };
}

