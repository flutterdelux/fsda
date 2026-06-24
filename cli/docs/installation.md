# FSDA CLI Installation

To install and activate the FSDA CLI globally so that the `fsda` command is available anywhere in your terminal, follow these steps:

## Local Development Installation

1. Navigate to the `cli/fsda_cli` directory in your project workspace:
   ```bash
   cd cli/fsda_cli
   ```

2. Run the Dart pub global activate command pointing to the local source directory:
   ```bash
   rm -rf .dart_tool/pub/bin
   dart pub global activate --source path .
   ```

3. **Verify Installation:**
   After activation, you should be able to run `fsda` from any terminal window:
   ```bash
   fsda --version
   ```

> [!NOTE]
> If your terminal says `command not found: fsda`, you may need to ensure your Dart global packages directory is added to your system's PATH. 
> 
> **For macOS/Linux (zsh):**
> Add this to your `~/.zshrc` or `~/.bashrc`:
> ```bash
> export PATH="$PATH":"$HOME/.pub-cache/bin"
> ```
> Then run `source ~/.zshrc`.

## Template Resolution

The `fsda` CLI requires the `assets/generators` folder to function correctly. The CLI is programmed to automatically locate the `assets/generators` directory relative to the globally activated package installation (using Dart Isolates).

Once activated globally, you can safely navigate to a fresh directory anywhere on your computer (e.g., `examples/fsda-base`) and run generation commands. The CLI will automatically pull the templates from your central `fsda` repository.