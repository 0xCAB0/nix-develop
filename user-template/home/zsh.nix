# File: ~/.config/nixos/home/zsh.nix
# Zsh configuration based on the provided .zshrc

{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "ssh"
        "aliases"
        "python"
        "dotenv"
        "docker"
        "mvn"
      ];
    };
    
    # Enable command correction
    autosuggestion.enable = true;
    enableCompletion = true;
    
    # History configuration
    history = {
      size = 10000;
      save = 10000;
    };
    
    # Shell aliases
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      # Add any other aliases from the original .zshrc here
    };
    
    # Additional shell initialization
    initExtraFirst = ''
      # Set editor to neovim
      export EDITOR=nvim
      
      # History timestamp format
      export HIST_STAMPS="mm/dd/yyyy"
      
      # Add just completions if available
      if command -v just >/dev/null 2>&1; then
        eval "$(just --completions zsh)"
      fi
      
      # Add zoxide if available
      if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init zsh)"
      fi
      
      # ASDF integration if available
      if [ -f "$HOME/.asdf/asdf.sh" ]; then
        source "$HOME/.asdf/asdf.sh"
        fpath=(''${ASDF_DIR}/completions $fpath)
        autoload -Uz compinit && compinit
      fi
    '';
  };
}