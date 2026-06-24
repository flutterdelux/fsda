import 'package:freezed_annotation/freezed_annotation.dart';

part 'generation_result.freezed.dart';

@freezed
sealed class GenerationResult with _$GenerationResult {
  factory GenerationResult.success({
    required String message,
    @Default([]) List<String> files,
  }) = _GenerationResultSuccess;

  factory GenerationResult.failure({required String message}) =
      _GenerationResultFailure;
}
