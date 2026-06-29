enum GenType {
  app,
  module,
  feature,
  slice;

  factory GenType.fromValue(String value) {
    return switch (value) {
      'app' || 'a' => GenType.app,
      'module' || 'm' => GenType.module,
      'feature' || 'f' => GenType.feature,
      'slice' || 's' => GenType.slice,
      _ => throw ArgumentError('Invalid Gen Type: $value'),
    };
  }
}
