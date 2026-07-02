import 'package:freezed_annotation/freezed_annotation.dart';

part 'reg_argument.freezed.dart';

@freezed
abstract class RegArgument with _$RegArgument {
  const RegArgument._();

  factory RegArgument({String? app, String? module}) = _RegArgument;
}
