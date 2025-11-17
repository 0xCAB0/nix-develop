{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    just
    direnv
    git
    ripgrep
    fd
    jq
    curl
    vim
  ];

  shellHook = ''
    export EDITOR="${pkgs.vim}/bin/vim"

    # If there's an .envrc suggest direnv usage (don't auto-allow).
    if [ -f .envrc ]; then
      echo "Found .envrc — run 'direnv allow' to load environment"
    fi

    # Provide a helpful prompt note for 'just'
    if command -v just >/dev/null 2>&1; then
      echo "just is available — run 'just --list' to see targets"
    fi
  '';
}
