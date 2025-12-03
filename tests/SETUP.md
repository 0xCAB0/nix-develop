# How to work with tests

This test suite was heavily inspired by the official [NixOS-WSL](https://github.com/nix-community/NixOS-WSL/tree/main/tests#readme) test suite, so we will just provide information about our special use cases in this readme.

Refer to their docs for a deeper understanding of the testing environment.

## Requirements

### Constrains
- This test suite runs **only** on Windows machines.
- This test suite also requires an already compiled `nix-develop.wsl` build to present in the current workspace.

1. [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5&viewFallbackFrom=powershell-7.2)

> [!INFO]
> You can use this [official guide](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.5) to install it on Ubuntu/Debian based systems

2. [Pester](https://pester.dev/docs/introduction/installation/#linux--macos)

## Running the test suite

> [!NOTE]
> Run the test suite from the root of the repository

```powershell
Invoke-Pester -Output Detailed ./tests
```

## Contribute with more tests

> We encourage to follow guidance provided by [NixOS-WSL](https://github.com/nix-community/NixOS-WSL/tree/main/tests#writing-test) repo on how to write tests for WSL instances.