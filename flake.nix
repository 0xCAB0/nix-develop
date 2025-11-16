{
  description = "Base NixOS-WSL config for Thalos dev team";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }: {
    
    # --- OUTPUT 1: The Base System Configuration ---
    # We output a 'module' that other flakes can import.
    nixosModules.default = {
      imports = [
        nixos-wsl.nixosModules.wsl
        ./configuration.nix
        
        # Import the home-manager module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # We import the TEAM-WIDE home.nix here
          # This will be applied to the user
          home-manager.users.dev = import ./home.nix;
        }
      ];
    };

    # --- OUTPUT 2: The User-Specific Overrides (Optional) ---
    # This is a good pattern. You can provide a separate
    homeManagerModules.default = import ./home.nix;
    
    # --- OUTPUT 3: The WSL Tarball (Optional) ---
    packages.x86_64-linux.default = let
      nixosSystem = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit home-manager; };
        modules = [ self.nixosModules.default ];
      };
    in
      nixosSystem.config.system.build.wslTarball;
  };
}
