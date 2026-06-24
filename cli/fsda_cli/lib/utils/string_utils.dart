class StringUtils {
  static String toSnakeCase(String text) {
    return text.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    }).replaceFirst(RegExp(r'^_'), '');
  }

  static String toPascalCase(String text) {
    if (text.isEmpty) return text;
    final words = text.split(RegExp(r'[_\s-]'));
    return words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  static String toCamelCase(String text) {
    final pascalCase = toPascalCase(text);
    if (pascalCase.isEmpty) return pascalCase;
    return pascalCase[0].toLowerCase() + pascalCase.substring(1);
  }
}
