import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mason/mason.dart';

import '../enums/sequence_code.dart';

part 'gen_argument.freezed.dart';

@freezed
abstract class GenArgument with _$GenArgument {
  const GenArgument._();

  factory GenArgument({
    String? app,
    String? module,
    String? feature,
    String? slice,
    String? sequence,
    String? method,
  }) = _GenArgument;

  String get resolvedMethodName {
    if (method != null) return method!;

    if (feature == null || feature!.isEmpty) {
      throw ArgumentError('Feature name is required to resolve method name.');
    }

    if (slice == null || slice!.isEmpty) {
      throw ArgumentError('Slice name is required to resolve method name.');
    }

    if (sequence == null || sequence!.isEmpty) {
      throw ArgumentError('Sequence code is required to resolve method name.');
    }

    final sequenceCode = SequenceCode.fromValue(sequence!);

    if (sequenceCode.isMutation) {
      return '${slice!.camelCase}${feature!.pascalCase}';
    }
    return '${feature!.camelCase}${slice!.pascalCase}';
  }
}
