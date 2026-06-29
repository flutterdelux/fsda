# FSDA CLI 

1. Navigate to the `cli/fsda_cli` directory in your project workspace:
   ```bash
   cd cli/fsda_cli
   ```

2. Run the Dart pub global activate command pointing to the local source directory:
   ```bash
   mason bundle bricks/sequence_m -t dart -o lib/generated/bricks
   mason bundle bricks/feature -t dart -o lib/generated/bricks
   mason bundle bricks/module -t dart -o lib/generated/bricks
   mason bundle bricks/app -t dart -o lib/generated/bricks
   dart run tools/generate_bundle.dart
   rm -rf .dart_tool/pub/bin
   dart pub global activate --source path .
   ```

3. **Verify Installation:**
   After activation, you should be able to run `fsda` from any terminal window:
   ```bash
   fsda --version
   ```
