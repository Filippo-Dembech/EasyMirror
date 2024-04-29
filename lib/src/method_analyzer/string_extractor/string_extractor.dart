import 'extracting_strategies/extraction.dart';
import 'extracting_strategies/matching_delimiters_extraction.dart';
import 'extracting_strategies/extractions.dart';
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
  String extractsStringWithin(Delimiters delimiters) =>
      _extractionStrategy.extract(_text, delimiters);
}
