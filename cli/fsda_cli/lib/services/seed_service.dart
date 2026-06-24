import '../models/seed_package.dart';

abstract class SeedService {
  Future<SeedPackage> loadPackage(String name);
  Future<SeedPackage> loadInfra(String name);
}
