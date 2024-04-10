import 'Extracting Strategies/extraction.dart';
import 'Extracting Strategies/matching_delimiters_extraction.dart';
import 'delimiters.dart';


class StringExtractor {

  String _string = "";
  Delimiters _delimiters = Delimiters.ROUND_BRACKETS;
  Extraction _extractionStrategy = MatchingDelimitersExtraction();

  StringExtractor();
  StringExtractor.of(
    this._string);

  StringExtractor of(String string) {
    _string = string;
    return this;
  }

  StringExtractor within(Delimiters delimiters) {
    _delimiters = delimiters;
    return this;
  }

  String extract() => _extractionStrategy.extract(_string, _delimiters);

  String extractsStringWithin(Delimiters delimiters) =>
      _extractionStrategy.extract(_string, delimiters);

  StringExtractor using(Extraction extraction) {
      _extractionStrategy = extraction;
      return this;
  }
}
