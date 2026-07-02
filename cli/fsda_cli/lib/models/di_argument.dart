import 'package:freezed_annotation/freezed_annotation.dart';

part 'di_argument.freezed.dart';

@freezed
abstract class DiArgument with _$DiArgument {
  const DiArgument._();

  factory DiArgument({String? app, String? module}) = _DiArgument;
}
