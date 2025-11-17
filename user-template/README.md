# Personal NixOS-WSL Configuration

This is your personal configuration template for the NixOS-WSL development environment. This directory contains your user-specific settings that will be applied on top of the team's base configuration.

## Quick Start

After installing the WSL distribution, this configuration is automatically cloned to `~/.config/nixos` in your WSL environment.

### First-Time Setup

1. **Update your personal information**:
   ```bash
   cd ~/.config/nixos
   nano home/git.nix  # Update your name and email
   ```

2. **Add your personal packages**:
   ```bash
   nano home/packages.nix  # Add packages you need
   ```

3. **Apply your configuration**:
   ```bash
   nix flake update ~/.config/nixos
   sudo nixos-rebuild switch --flake ~/.config/nixos#wsl
   ```

## File Structure

```
~/.config/nixos/
├── flake.nix          # Your personal flake configuration
├── home.nix           # Your home-manager configuration
└── home/
    ├── git.nix        # Your Git configuration
    ├── zsh.nix        # Your Zsh configuration
    └── packages.nix   # Your personal packages
```

## Customization

### Git Configuration (`home/git.nix`)
Update your Git settings:
```nix
programs.git = {
  enable = true;
  settings = {
    user = {
      name = "Your Name";
      email = "your-email@company.com";
    };
  };
};
```

### Personal Packages (`home/packages.nix`)
Add tools you need:
```nix
home.packages = with pkgs; [
  sl              # Fun steam locomotive
  htop            # System monitor
  ripgrep         # Fast grep alternative
  # Add your packages here
];
```

### Zsh Configuration (`home/zsh.nix`)
The Zsh configuration is pre-configured with Oh My Zsh and useful plugins. You can customize:
- Aliases in `shellAliases`
- Additional shell initialization in `initExtraFirst`

## Updating Your Environment

### Update Packages
```bash
# Update flake inputs
nix flake update ~/.config/nixos

# Rebuild system
sudo nixos-rebuild switch --flake ~/.config/nixos#wsl
```

### Add New Packages
1. Edit `home/packages.nix`
2. Run `sudo nixos-rebuild switch --flake ~/.config/nixos#wsl`

## Team Configuration

Your personal configuration builds on top of the team's base configuration which includes:
- Docker with custom settings
- Node.js 22 and JDK 17
- Essential development tools (git, neovim, curl, wget)
- Zsh with Oh My Zsh

## Troubleshooting

### Configuration Errors
If you encounter errors during rebuild:
```bash
# Check configuration syntax
nix flake check ~/.config/nixos
```

### Reset to Default
If you need to reset your configuration:
```bash
cd ~/.config/nixos
git checkout .
sudo nixos-rebuild switch --flake ~/.config/nixos#wsl
```

## Getting Help

- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **Home Manager Manual**: https://nix-community.github.io/home-manager/
- **Package Search**: https://search.nixos.org/packages