# File: flake.nix
# -----------------
# This is the entry point. It defines the project's dependencies
# (Nixpkgs, NixOS-WSL, Home Manager) and its outputs (the
# WSL system configuration and the tarball).

{
  description = "NixOS-WSL configuration for [Your Team Name]";

  inputs = {
    # Nixpkgs (for packages)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Home Manager (for user-level configs)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Build a NixOS system configured with our modules
        nixosSystem = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit home-manager; }; # Pass home-manager to the config
          modules = [
            # Import the NixOS-WSL module
            nixos-wsl.nixosModules.wsl

            # Import our custom system configuration
            ./configuration.nix

            # Import the Home Manager module for NixOS
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                # You can pass special args to home-manager configs if needed
              };
              # Define our user's home-manager config
              home-manager.users.dev = import ./user-template/home.nix;
            }
          ];
        };
      in
      {
        # The main configuration to be built
        nixosConfigurations.wsl-dev-env = nixosSystem;

        # This packages the configuration as a WSL tarball
        # Build it with: sudo nix run .#wsl-tarball
        packages.wsl-tarball = nixpkgs.legacyPackages.${system}.writeShellScriptBin "wsl-tarball-builder" ''
          set -e
          
          # Create output directory
          mkdir -p output
          
          # Run the tarball builder
          ${nixosSystem.config.system.build.tarballBuilder}/bin/nixos-wsl-tarball-builder
          
          # Move the generated tarball to output/nixos.wsl
          if [ -f nixos.wsl ]; then
            mv nixos.wsl output/nixos.wsl
            echo "WSL tarball created at: output/nixos.wsl"
          else
            echo "Error: nixos.wsl not found after build"
            exit 1
          fi
        '';
        
        # Make it the default package
        # Build it with: nix build
        packages.default = self.packages.${system}.wsl-tarball;

      });
}
