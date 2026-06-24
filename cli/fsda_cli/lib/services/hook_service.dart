import 'process_service.dart';

class HookService {
  final ProcessService process;

  HookService(this.process);

  Future<void> run(List<String> hooks, {required String cwd}) async {
    for (final hook in hooks) {
      await _execute(hook, cwd);
    }
  }

  Future<void> _execute(String hook, String cwd) async {
    final parts = hook.split(' ');
    final command = parts.first;
    final args = parts.sublist(1);

    await process.run(command, args, workingDirectory: cwd);
  }
}
