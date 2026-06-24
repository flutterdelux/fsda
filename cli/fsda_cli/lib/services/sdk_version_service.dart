import 'dart:io';

class SdkVersionService {
  /// Ambil Dart version dari Flutter runtime
  String getDartVersion() {
    final raw = Platform.version;
    return raw.split(' ').first; // 3.10.7
  }

  /// Convert ke caret format ^3.10.7
  String getCaretVersion() {
    final v = getDartVersion();
    return '^$v';
  }
}
