import 'dart:io';

class LoggerService {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';

  void info(String message) {
    stdout.writeln('$_blue[INFO]$_reset $message');
  }

  void success(String message) {
    stdout.writeln('$_green[SUCCESS]$_reset $message');
  }

  void warning(String message) {
    stdout.writeln('$_yellow[WARNING]$_reset $message');
  }

  void error(String message) {
    stderr.writeln('$_red[ERROR]$_reset $message');
  }

  void log(String message) {
    stdout.writeln(message);
  }
}
