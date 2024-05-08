import 'package:easy_mirror/src/method_analyzer/extensions/list__empty_string_remover.dart';
import 'delimiters.dart';

/// Extracts substring delimited by defined delimiters
/// from a passed text. You can use different strategies
/// to define the delimiting area. Check [Extractions] to
/// understand which strategy you can use. Depending on
/// the used strategy the extracted substring may vary.
class StringExtractor {
  String _text = "";
  Extraction _extractionStrategy = MatchingDelimitersExtraction();

  StringExtractor();

  /// Creates the [StringExtractor] with the associated
  /// text which has to be parsed. To define [Delimiters]
  /// use [StringExtractor.within] method. To define
  /// the extracting strategy use the [StringExtractor.using] method.
  StringExtractor.parsing(
    this._text,
  );

  // ! DEPRECATED
  /// Defines the [text] parsed by the [StringExtractor]
  // StringExtractor parsing(String text) {
  //   _text = text;
  //  return this;
  // }

  // ! DEPRECATED
  /// Defines the [Delimiters] used to parse this
  /// text.
  // StringExtractor within(Delimiters delimiters) {
  //   _delimiters = delimiters;
  //   return this;
  // }

  /// Defines the [Extraction] strategy used to
  /// define the delimiting area.
  StringExtractor using(Extraction extraction) {
    _extractionStrategy = extraction;
    return this;
  }

  // ! DEPRECATED
  /// Extracts the substrings of the passed text within the
  /// [Delimiters] defined with the [StringExtractor.within] method.
  /// The way the delimiting area is computed depends on the
  /// [Extraction] strategy that has been defined
  /// with the [StringExtractor.using] method - [MatchingDelimitersExtraction] by default.
  /// Check [Extractions] class to check all the available
  /// strategies. [Delimiters] are [Delimiters.ROUND_BRACKETS] by default.
  // String extracts() => _extractionStrategy.extract(_text, _delimiters);

  /// Extracts the substrings of the passed text within the passed
  /// [Delimiters]. The way the delimiting area is computed depends on the
  /// [Extraction] strategy that has been defined
  /// with the [StringExtractor.using] method - [MatchingDelimitersExtraction] by default.
  /// Check [Extractions] class to check all the available
  /// strategies.
  List<String> extractsStringWithin(Delimiters delimiters) {
      return _extractionStrategy.extract(_text, delimiters); // TODO: remove index [0]
  }
}

class Extractions {
  static Extraction viseExtraction() => ViseExtraction();
  static Extraction matchingDelimitersExtraction() =>
      MatchingDelimitersExtraction();
}

/// Define the algorithm that the [StringExtractor]
/// can use to parse its text and extract the substring
/// within the delimiters.
abstract class Extraction {
  const Extraction();
  List<String> extract(String string, Delimiters delimiters);
}

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
  List<String> extract(String string, Delimiters delimiters) {
    List<String> result = [];
    for (var indexes in Delimiters.allMatchesIndexes(delimiters, string)) {
      result.add(string.substring(indexes.$1 + 1, indexes.$2));
    };
    return result.withoutEmptyStrings();
  }


}

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

  List<String> extract(String string, Delimiters delimiters) {
    int firstOpeningDelimiterIndex = string.indexOf(delimiters.opening) + 1;
    int lastClosingDelimiterIndex = string.lastIndexOf(delimiters.closing);

    if (firstOpeningDelimiterIndex != -1 && lastClosingDelimiterIndex != -1)
      return [string.substring(
          firstOpeningDelimiterIndex, lastClosingDelimiterIndex)].withoutEmptyStrings();
    else
      return [];
  }
}

class UnmatchingDelimitersException implements Exception {
  Delimiters _delimiters;
  int _openingDelimitersCount = 0;
  int _closingDelimitersCount = 0;

  UnmatchingDelimitersException(
    this._delimiters,
    this._openingDelimitersCount,
    this._closingDelimitersCount,
  );

  @override
  String toString() =>
      "NonMatchingDelimitersException: non matching delimiters '${_delimiters.opening}' -> count: $_openingDelimitersCount, '${_delimiters.closing}' -> count: $_closingDelimitersCount";
}
