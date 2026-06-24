import 'dart:io';

class ProcessService {
  Future<void> run(
    String command,
    List<String> args, {
    required String workingDirectory,
  }) async {
    final result = await Process.run(
      command,
      args,
      workingDirectory: workingDirectory,
    );

    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }
  }
}
