import '../delimiters.dart';
import '../string_extractor.dart';
import 'extraction.dart';

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
