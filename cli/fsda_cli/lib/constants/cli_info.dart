abstract final class CliInfo {
  static const name = 'fsda_cli';
  static const executable = 'fsda';
  static const version = '0.0.2';
  static const description = 'Feature Slice Driven Architecture CLI';

  static String getConfigYaml({
    required String workspaceName,
    required List<String> packages,
  }) =>
      '''
workspace: $workspaceName
created_at: '${DateTime.now().toIso8601String()}'

fsda_cli: '$version'

init:
  packages:
${packages.map((e) => '    - $e').join('\n')}
''';

  static const retrievalCheckpoint = '// ------- Retrieval -------';
  static const mutationCheckpoint = '// ------- Mutation -------';
}
