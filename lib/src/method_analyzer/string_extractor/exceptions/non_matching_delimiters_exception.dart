import '../delimiters.dart';
import '../string_extractor.dart';

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
