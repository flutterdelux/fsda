import 'dart:io';

import 'package:yaml/yaml.dart';

import '../services/logger_service.dart';
import 'package_generator.dart';

class InitGenerator {
  final LoggerService logger;
  final PackageGenerator packageGenerator;

  const InitGenerator({required this.packageGenerator, required this.logger});

  Future<void> generate() async {
    try {
      final configFile = File('fsda.yaml');
      final yamlString = await configFile.readAsString();
      final doc = loadYaml(yamlString);

      // Defensive Parsing
      if (doc is! YamlMap || !doc.containsKey('init')) {
        logger.error('Format fsda.yaml broken: Key "init:" not found.');
        return;
      }

      final initNode = doc['init'];
      if (initNode is! YamlMap || !initNode.containsKey('packages')) {
        logger.error(
          'Format fsda.yaml broken: Key "init -> packages:" not found.',
        );
        return;
      }

      final rawPackages = initNode['packages'];
      if (rawPackages is! YamlList) {
        logger.error('Format fsda.yaml broken: Key "packages" must be a list.');
        return;
      }

      // Safe casting
      final packages = rawPackages.map((e) => e.toString()).toList();

      logger.info('Initializing package base...');

      for (final package in packages) {
        final created = await packageGenerator.generate(package);
        if (!created) {
          logger.error('Failed to initialize package: $package');
          break;
        }
      }

      logger.success('All base packages have been successfully initialized!');
    } catch (e) {
      logger.error('Failed to read fsda.yaml configuration: $e');
    }
  }
}
