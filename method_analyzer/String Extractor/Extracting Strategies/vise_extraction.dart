import '../delimiters.dart';
import 'extraction.dart';

/// When [ViseExtraction] is used by
/// [StringExtractor] the delimiting area is defined
/// as the area between the first occurrence of the
/// first opening delimiter and the last occurrence
/// of the closing delimiter.
/// ---
/// Example:
/// Assuming that the delimiters are rounded brackets...
/// ```dart
/// "Hi (there)"  // returns -> "there"
/// "((Hi)) there" // returns -> "(Hi)"
/// "((Hi) there)" // returns -> "(Hi) There"
/// "(Hi) (there)" // returns -> "Hi) (there"
/// "((Hi there" // returns -> ""
/// ```
final class ViseExtraction extends Extraction {
  const ViseExtraction();

  String extract(String string, Delimiters delimiters) {
    int firstOpeningDelimiterIndex = string.indexOf(delimiters.opening) + 1;
    int lastClosingDelimiterIndex = string.lastIndexOf(delimiters.closing);

    return (firstOpeningDelimiterIndex == -1 || lastClosingDelimiterIndex == -1)
        ? ""
        : string.substring(
            firstOpeningDelimiterIndex, lastClosingDelimiterIndex);
  }
}
