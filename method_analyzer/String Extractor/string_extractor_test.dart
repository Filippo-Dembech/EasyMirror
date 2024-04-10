import 'Extracting Strategies/extractions.dart';
import 'Extracting Strategies/matching_delimiters_extraction.dart';
import 'Extracting Strategies/vise_extraction.dart';
import 'delimiters.dart';
import 'string_extractor.dart';

void main() {
  String testingString = "<(hi) there [<were are] you?>>>";
  var extractor = StringExtractor.of(testingString);
  print(extractor.extract());
}