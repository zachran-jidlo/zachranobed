/// Extensions on String for searching and filtering.
extension StringSearchUtils on String {
  /// Lowercase Czech and Slovak accented characters mapped to their ASCII base.
  static const Map<String, String> _czSkDiacritics = {
    'á': 'a',
    'ä': 'a',
    'č': 'c',
    'ď': 'd',
    'é': 'e',
    'ě': 'e',
    'í': 'i',
    'ĺ': 'l',
    'ľ': 'l',
    'ň': 'n',
    'ó': 'o',
    'ô': 'o',
    'ŕ': 'r',
    'ř': 'r',
    'š': 's',
    'ť': 't',
    'ú': 'u',
    'ů': 'u',
    'ý': 'y',
    'ž': 'z',
  };

  /// Returns the string lowercased, trimmed and with Czech/Slovak diacritics
  /// removed. Use it for case- and accent-insensitive matching.
  String get searchNormalized {
    final buffer = StringBuffer();
    for (final char in toLowerCase().trim().split('')) {
      buffer.write(_czSkDiacritics[char] ?? char);
    }
    return buffer.toString();
  }
}
