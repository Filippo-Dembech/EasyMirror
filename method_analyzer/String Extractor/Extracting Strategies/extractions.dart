import 'extraction.dart';
import 'matching_delimiters_extraction.dart';
import 'vise_extraction.dart';

class Extractions {

  static Extraction viseExtraction() => ViseExtraction();
  static Extraction matchingDelimitersExtraction() => MatchingDelimitersExtraction();
}