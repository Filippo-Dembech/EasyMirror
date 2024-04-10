import '../../Extensions/string__char_count.dart';
import '../Exceptions/non_matching_delimiters_exception.dart';
import '../delimiters.dart';
import 'extraction.dart';

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