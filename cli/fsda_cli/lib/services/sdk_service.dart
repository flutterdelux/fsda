import 'dart:io';

class SdkService {
  /// Get the current Dart SDK version
  /// Example: 3.10.7
  String get dartVersion {
    final raw = Platform.version;
    return raw.split(' ').first;
  }
}
