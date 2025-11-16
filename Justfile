build-tar:
	sudo nix run github:nix-community/NixOS-WSL#nixosConfigurations.default.config.system.build.tarballBuilder
