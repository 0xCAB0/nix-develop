# setup-dev-env.ps1
# ------------------------------------------------------------------
# Automated Setup for NixOS-WSL Development Environment
# ------------------------------------------------------------------

$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- Configuration Variables ---
$DistroName = "NixOS-Dev"
$InstallDir = "C:\WSL\$DistroName"
$TarballUrl = "https://github.com/0xCAB0/nix-develop/releases/latest/download/nix-develop.wsl"
$TarballFile = "$InstallDir\nix-develop.wsl"
$RepoUrl = "https://github.com/0xCAB0/nix-develop.git"
$ConfigBranch = "user_template"
$User = "dev" # Default user defined in your main flake

Write-Host "🚀 Starting Development Environment Setup..." -ForegroundColor Cyan

# 1. Check for existing installation
if (wsl --list --quiet | Select-String -Pattern $DistroName) {
    Write-Warning "Distro '$DistroName' is already installed."
    $confirmation = Read-Host "Do you want to delete it and reinstall? (y/N)"
    if ($confirmation -ne 'y') {
        Write-Host "Aborting setup."
        exit
    }
    Write-Host "Unregistering existing distro..." -ForegroundColor Yellow
    wsl --unregister $DistroName
}

# 2. Create Installation Directory
if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
    Write-Host "Created directory: $InstallDir" -ForegroundColor Green
}

# 3. Download the WSL Tarball
Write-Host "⬇️  Downloading NixOS-WSL image..." -ForegroundColor Cyan

# Clean up if a partial file exists from a failed run
if (Test-Path $TarballFile) {
    Write-Warning "Found existing file, removing..."
    Remove-Item $TarballFile -Force
}

# Use curl.exe (Built-in to Windows 10/11 and runs as current user, bypassing BITS permission issues)
& curl.exe -L -o $TarballFile $TarballUrl

if ($LASTEXITCODE -ne 0) {
    Write-Error "Download failed. Check your internet connection."
    exit
}

Write-Host "Download complete." -ForegroundColor Green
# 4. Import the WSL Distro
Write-Host "📦 Importing NixOS distribution..." -ForegroundColor Cyan
wsl --import $DistroName $InstallDir $TarballFile --version 2
Write-Host "Import complete." -ForegroundColor Green

# 5. Bootstrap User Configuration
# We execute these commands INSIDE the new WSL instance
Write-Host "🔧 Bootstrapping user configuration from branch '$ConfigBranch'..." -ForegroundColor Cyan

$bootstrapCmd = "
    mkdir -p ~/.config && 
    echo 'Cloning user template...' && 
    if [ ! -d ~/.config/nixos ]; then
        git clone -b $ConfigBranch $RepoUrl ~/.config/nixos
    else
        echo 'Config directory already exists, skipping clone.'
    fi
"

# Execute the bootstrap command as the 'dev' user
wsl -d $DistroName -u $User -- sh -c $bootstrapCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "Configuration cloned successfully to ~/.config/nixos" -ForegroundColor Green
} else {
    Write-Error "Failed to clone configuration repository."
}

# 6. Cleanup
if (Test-Path $TarballFile) {
    Remove-Item $TarballFile
    Write-Host "Cleaned up temporary files." -ForegroundColor Gray
}

# 7. Success Message
Write-Host "`n✅ Setup Complete!" -ForegroundColor Green
Write-Host "---------------------------------------------------------"
Write-Host "To start your new environment, run:"
Write-Host "   wsl -d $DistroName" -ForegroundColor Yellow
Write-Host "---------------------------------------------------------"
Write-Host "Inside, run the following to apply updates in the future:"
Write-Host "   nix flake update ~/.config/nixos"
Write-Host "   sudo nixos-rebuild switch --flake ~/.config/nixos#wsl"
Write-Host "---------------------------------------------------------"