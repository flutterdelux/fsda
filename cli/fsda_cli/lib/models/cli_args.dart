import 'package:freezed_annotation/freezed_annotation.dart';

part 'cli_args.freezed.dart';

@freezed
abstract class CliArgs with _$CliArgs {
  const factory CliArgs({
    required String command,
    String? type,
    String? name,
    @Default({}) Map<String, dynamic> flags,
  }) = _CliArgs;
}
