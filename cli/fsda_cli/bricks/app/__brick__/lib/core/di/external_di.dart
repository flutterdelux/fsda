import 'package:dio/dio.dart';

import 'di.dart';

Future<void> externalDI() async {
  sl.registerLazySingleton<Dio>(() => Dio());
}
