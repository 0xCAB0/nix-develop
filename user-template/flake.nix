{
  description = "My personal WSL config";

  inputs = {
    # 1. Get the official Nix packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 2. Get the official home-manager
    home-manager.url = "github:nix-community/home-manager";

    dev-env = {
      url = "github:0xCAB0/nix-develop";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, dev-env }: {
    # Define your WSL system
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager; };
      modules = [
        # 1. Import the ENTIRE team configuration
        dev-env.nixosModules.default

        # 2. (Optional) Import your own system-level tweaks
        # ./my-system.nix 

        # 3. Import your PERSONAL home.nix for secrets
        home-manager.nixosModules.home-manager
        {
          home-manager.users.dev = import ./home.nix;
        }
      ];
    };
  };
}
