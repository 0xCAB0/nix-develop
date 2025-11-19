# File: configuration.nix
# -------------------------
# This is the main system configuration. It's equivalent to
# what you'd find in /etc/nixos/configuration.nix on a
# normal NixOS machine.

{ config, pkgs, lib, ... }:

{
  # --- NixOS-WSL Configuration ---
  wsl = {
    enable = true;
    defaultUser = "dev";
    wslConf = {
      wsl2 = {
        guiApplications = false;
      };  
      boot.command = ''
        mkdir -p ~/.config && 
        echo 'Cloning user template...' && 
        if [ ! -d ~/.config/nixos ]; then
            git clone -b $ConfigBranch $RepoUrl ~/.config/nixos
        else
            echo 'Config directory already exists, skipping clone.'
        fi
      '';
    };
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
    nodejs_22
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

