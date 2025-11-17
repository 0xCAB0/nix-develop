build-tar:
	sudo nix run .#wsl-tarball

# Clean output directory
clean:
	rm -rf output/

# Show build info
info:
	@echo "WSL tarball will be created at: output/nixos.wsl"
	@echo "Run 'just build-tar' to build the tarball"
