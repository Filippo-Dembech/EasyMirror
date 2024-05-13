import 'package:easy_mirror/src/method_analyzer/extensions/list__empty_string_remover.dart';
import 'delimiters.dart';

/// Extracts substring delimited by defined delimiters
/// from a passed text. You can use different strategies
/// to define the delimiting area. Check [Extractions] to
/// understand which strategy you can use. Depending on
/// the used strategy the extracted substring may vary.
class StringExtractor {
  String _text = "";
  Extraction _extractionStrategy = PluckExtraction();

  StringExtractor();

  /// Creates the [StringExtractor] with the associated
  /// text which has to be parsed. To define [Delimiters]
  /// use [StringExtractor.within] method. To define
  /// the extracting strategy use the [StringExtractor.using] method.
  StringExtractor.parsing(
    this._text,
  );

  /// Defines the [Extraction] strategy used to
  /// define the delimiting area.
  StringExtractor using(Extraction extraction) {
    _extractionStrategy = extraction;
    return this;
  }


  /// Extracts the first substring of the passed text within the passed
  /// [Delimiters]. The way the delimiting area is computed depends on the
  /// [Extraction] strategy that has been defined
  /// with the [StringExtractor.using] method - [PluckExtraction] by default.
  /// Check [Extractions] class to check all the available
  /// strategies.
  String extractsFirstStringWithin(Delimiters delimiters) {
    List<String> extractedList = _extractionStrategy.extract(_text, delimiters);
    if (extractedList.isEmpty) return "";
    return extractedList[0];
  }

  /// Extracts the substrings of the passed text within the passed
  /// [Delimiters]. The way the delimiting area is computed depends on the
  /// [Extraction] strategy that has been defined
  /// with the [StringExtractor.using] method - [PluckExtraction] by default.
  /// Check [Extractions] class to check all the available
  /// strategies.
  List<String> extractsStringWithin(Delimiters delimiters) {
      return _extractionStrategy.extract(_text, delimiters);
  }
}

class Extractions {
  static Extraction viseExtraction() => ViseExtraction();
  static Extraction pluckExtraction() => PluckExtraction();
}

/// Define the algorithm that the [StringExtractor]
/// can use to parse its text and extract the substring
/// within the delimiters.
abstract class Extraction {
  const Extraction();
  List<String> extract(String string, Delimiters delimiters);
}

/// When [PluckExtraction] is used by
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
final class PluckExtraction extends Extraction {
  const PluckExtraction();

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
