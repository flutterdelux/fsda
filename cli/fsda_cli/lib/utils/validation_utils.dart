class ValidationUtils {
  static bool isValidPackageName(String name) {
    final regExp = RegExp(r'^[a-z_][a-z0-9_]*$');
    return regExp.hasMatch(name);
  }
}
