import 'package:path/path.dart' as p;

class PathUtils {
  static String join(String part1, [String? part2, String? part3, String? part4]) {
    return p.joinAll([part1, ?part2, ?part3, ?part4]);
  }

  static String normalize(String path) {
    return p.normalize(path);
  }
}
