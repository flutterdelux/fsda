abstract final class CliRules {
  static const workspaceNamePattern = r'^[a-zA-Z][a-zA-Z0-9_-]*$';
  static String get workspaceNameRule => '''
Naming rules:
1. Must start with a letter (a-z)
2. Can only contain letters, numbers, underscores (_), or dashes (-)

Tips: If you want to use dash/underscore, type directly: fsda create Toko-Sepatu_01
Example: fsda create TokoSepatu_01 or fsda create Toko-Sepatu-01
''';

  static const appNamePattern = _snakeCasePattern;
  static String get appNameRule => '''$_snakeCaseRule
Tips: If you want to use underscore, type directly: fsda gen app toko_sepatu
Example: fsda gen app tokosepatu or fsda gen app toko_sepatu
''';

  static const packageNamePattern = _snakeCasePattern;
  static String get packageNameRule => '''$_snakeCaseRule
Tips: If you want to use underscore, type directly: fsda add package toko_sepatu_01
Example: fsda add package tokosepatu_01 or fsda add package toko_sepatu_01
''';

  static const moduleNamePattern = _snakeCasePattern;
  static String get moduleNameRule => '''$_snakeCaseRule
Tips: If you want to use underscore, type directly: fsda gen module app_auth
Example: fsda gen module app_auth or fsda gen module auth
''';

  static const featureNamePattern = _snakeCasePattern;
  static String get featureNameRule => '''$_snakeCaseRule
Tips: If you want to use underscore, type directly: fsda gen feature wallet
Example: fsda gen feature wallet or fsda gen feature transaction_category
''';

  static const sliceNamePattern = _snakeCasePattern;
  static String get sliceNameRule => '''$_snakeCaseRule
Tips: If you want to use underscore, type directly: fsda gen slice wallet
Example: fsda gen slice wallet or fsda gen slice transaction_category
''';
}

const _snakeCasePattern = r'^[a-z][a-z0-9_]*$';
const _snakeCaseRule = '''
Naming rules:
1. Must start with a letter (a-z)
2. Must be lowercase (a-z)
3. Can only contain letters, numbers, underscores (_)
''';
