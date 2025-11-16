# File: configuration.nix
# -------------------------
# This is the main system configuration. It's equivalent to
# what you'd find in /etc/nixos/configuration.nix on a
# normal NixOS machine.

{ config, pkgs, ... }:

{
  imports = [
    # We don't need a hardware-specific config for WSL
    # <nixpkgs/nixos/modules/profiles/no-hardware.nix>
  ];

  # --- NixOS-WSL Configuration ---
  wsl = {
    enable = true;
    defaultUser = "dev";
    interop.sshForwardAgent.enable = true;
  };

  # Set your time zone
  time.timeZone = "Europe/Madrid"; # TODO: Set your own

  # --- User Management ---
  users.users.dev = {
    isNormalUser = true;
    description = "Development User";
    extraGroups = [ "wheel" "docker" ]; # 'wheel' for sudo
    shell = pkgs.zsh; # Set Zsh as the default shell
  };
  
  # Allow sudo access for 'wheel' group
  security.sudo.wheelNeedsPassword = false; # Common for WSL for convenience
 
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
    daemon.config = {
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

  # --- Systemd Services ---
  
  systemd.services."docker" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release version
  system.stateVersion = "25.05"; 
}
