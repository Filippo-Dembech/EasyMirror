import '../delimiters.dart';

/// Define the algorithm that the [StringExtractor]
/// can use to parse its text and extract the substring
/// within the delimiters.
abstract class Extraction {
  const Extraction();
  String extract(String string, Delimiters delimiters);
}