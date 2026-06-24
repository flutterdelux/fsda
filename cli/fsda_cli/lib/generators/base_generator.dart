import '../models/generation_result.dart';

import '../services/logger_service.dart';

abstract class BaseGenerator {
  final LoggerService logger;

  const BaseGenerator({required this.logger});

  Future<GenerationResult> generate(Map<String, dynamic> args);
}
