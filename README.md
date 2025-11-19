# NixOS-WSL Development Environment

A standardized NixOS-WSL development environment that provides a consistent, reproducible setup for development teams. This project creates a distributable WSL tarball with pre-configured development tools and allows individual user customization.

## Features

- **Standardized Environment**: Consistent development setup across all team members
- **User Customization**: Personal configuration template for individual preferences
- **Docker Support**: Pre-configured Docker with custom daemon settings
- **Development Tools**: Node.js 22, JDK 17, Git, Neovim, and essential utilities
- **Shell Environment**: Zsh with Oh My Zsh and useful plugins
- **Automated Distribution**: PowerShell installer for easy deployment

## Quick Start for Maintainers

### Prerequisites

- Nix with flakes enabled
- `just` command runner
- `sudo` access for tarball building

### Building the WSL Tarball

```bash
# Build the WSL tarball
just build-tar

# The tarball will be created at: output/nixos.wsl
```

### Available Commands

```bash
just build-tar    # Build WSL tarball
just clean        # Remove output directory
just info         # Show build information
```

## Project Structure

```
nix-develop/
├── flake.nix              # Main flake configuration
├── configuration.nix      # System-level configuration
├── shell.nix              # Development shell
├── Justfile               # Build commands
├── scripts/
│   └── install.ps1        # PowerShell installer
└── user-template/         # User configuration template
    ├── flake.nix          # User's personal flake
    ├── home.nix           # Home Manager configuration
    ├── README.md          # User documentation
    └── home/
        ├── git.nix        # Git configuration template
        ├── zsh.nix        # Zsh configuration
        └── packages.nix   # Personal packages template
```

## System Configuration

### Base Packages (`configuration.nix`)
- **Development**: Node.js 22, JDK 17, Git, Neovim
- **Shell Tools**: Zsh, Bat, Curl, Wget
- **System**: Docker with custom settings

### WSL Configuration
- Default user: `dev`
- Sudo without password for wheel group
- Time zone: Europe/Madrid (configurable)
- Docker enabled with custom daemon settings

### Home Manager Integration
- User-specific configurations via `user-template/`
- Git, Zsh, and package customization
- Automatic deployment to user's home directory

## Distribution

### PowerShell Installer (`scripts/install.ps1`)

The installer automates:
1. WSL distro installation from GitHub releases

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/0xCAB0/nix-develop/refs/heads/main/scripts/install.ps1' | iex"
```

2. User configuration bootstrap from template branch
3. Environment setup and validation

**Configuration Variables**:
```powershell
$DistroName = "NixOS-Dev"
$InstallDir = "C:\WSL\$DistroName"
$TarballUrl = "https://github.com/acabociu-ntt/nix-develop/releases/latest/download/nix-develop.wsl"
$ConfigBranch = "user_template"
```

### Release Process

1. **Build tarball**: `just build-tar`
2. **Create GitHub release** with `output/nixos.wsl`
3. **Update installer URL** if needed
4. **Test installation** on target systems

## User Workflow

### Initial Setup
1. Run PowerShell installer
2. Launch WSL: `wsl -d NixOS-Dev`
3. Customize configuration in `~/.config/nixos/`
4. Apply changes: `sudo nixos-rebuild switch --flake ~/.config/nixos#wsl`

### Updates
Users can update their environment:
```bash
nix flake update ~/.config/nixos
sudo nixos-rebuild switch --flake ~/.config/nixos#wsl
```

## Development

### Local Testing

```bash
# Enter development shell
nix develop

# Test configuration
nix flake check

# Build and test tarball
just build-tar
```

### Adding System Packages

Edit `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Add new system-wide packages here
  new-package
];
```

### Modifying User Template

Update files in `user-template/`:
- `home.nix` - Main home configuration
- `home/*.nix` - Specific tool configurations

### Docker Configuration

Docker is pre-configured with:
- TLS disabled (for Zscaler compatibility)
- Debug mode enabled
- Insecure registry: docker.io

## Troubleshooting

### Build Issues

```bash
# Check flake syntax
nix flake check

# Rebuild with trace
nix build --show-trace

# Clean and rebuild
just clean && just build-tar
```

### Common Problems

1. **Git tree dirty warning**: Commit changes before building
2. **Permission errors**: Ensure sudo access for tarball builder
3. **Package conflicts**: Check for duplicate package definitions

### Debugging

```bash
# Check system configuration
nix eval .#nixosConfigurations.wsl-dev-env.config.system.build

# Test in development shell
nix develop
```

## Contributing

1. Make changes to configuration files
2. Test locally with `just build-tar`
3. Update documentation if needed
4. Create pull request with changes

## Resources

- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **NixOS-WSL**: https://github.com/nix-community/NixOS-WSL
- **Home Manager**: https://github.com/nix-community/home-manager
- **Package Search**: https://search.nixos.org/packages