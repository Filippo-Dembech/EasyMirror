import '../../extensions/string__char_count.dart';
import '../exceptions/non_matching_delimiters_exception.dart';
import '../delimiters.dart';
import 'extraction.dart';


/// When [MatchingDelimitersExtraction] is used by
/// [StringExtractor] the delimiting area is defined
/// as the first area of the parsed text where
/// the amount of opening delimiters is equal to the
/// amount of closing delimiters.
/// ---
/// Example:
/// Given that the delimiters are round brackets...
/// ```dart
/// "Hi (there)"  // returns -> "there"
/// "((Hi)) there" // returns -> "(Hi)"
/// "((Hi) there)" // returns -> "(Hi) There"
/// "(Hi) (there)" // returns -> "Hi"
/// "((Hi there" // throws NonMatchingDelimitersException
/// ```
final class MatchingDelimitersExtraction extends Extraction {
  const MatchingDelimitersExtraction();

  @override
  String extract(String string, Delimiters delimiters) {
    validateMatchingOf(string, delimiters);

    if (string.indexOf(delimiters.opening) == -1) return "";

    String delimitedSubstring =
    string.substring(string.indexOf(delimiters.opening));

    int openingDelimiterCount = 0;
    int closingDelimiterCount = 0;
    int substringEndingIndex = 0;

    for (int i = 0; i < delimitedSubstring.length; i++) {
      if (delimitedSubstring[i] == delimiters.opening) openingDelimiterCount++;
      if (delimitedSubstring[i] == delimiters.closing) closingDelimiterCount++;
      if (openingDelimiterCount == closingDelimiterCount) {
        substringEndingIndex = i;
        break;
      }
    }
    return delimitedSubstring.substring(1, substringEndingIndex);
  }


  /// If the number of opening delimiters isn't equal to the
  /// amount of closing delimiters [NonMatchingDelimitersException]
  /// is thrown because [MatchingDelimitersExtraction] relies
  /// on the assumption that the parsed text has a complete and
  /// finite set of matching delimiters.
  /// ---
  /// Example:
  /// ```dart
  /// String matching = "((hi) there)"
  /// String nonMatching = "((hi) there"
  /// StringExtractor.parsing(matching).extract(); // (hi) there
  /// StringExtractor.parsing(nonMatching).extract(); // throws NonMatchingDelimitersException
  /// ```
  /// The second extraction throws the exception because
  /// the `nonMatching` string has 2 opening delimiters (`(`)
  /// but only 1 closing delimiter (`)`). Because the amount
  /// between the opening and the closing delimiters isn't equal
  /// the exception is thrown.
  void validateMatchingOf(String string, Delimiters delimiters) {
    int openingDelimiterCount = string.counts(delimiters.opening);
    int closingDelimiterCount = string.counts(delimiters.closing);

    if (openingDelimiterCount != closingDelimiterCount)
      throw NonMatchingDelimitersException(
        delimiters,
        openingDelimiterCount,
        closingDelimiterCount,
      );
  }
}