import '../Extensions/list__empty_string_remover.dart';
import '../String Extractor/delimiters.dart';
import 'string_chopper.dart';
import 'skipping_iterator.dart';

class SkippingStringSplitter {
  final String _string;
  String _separator;
  final SkippingIterator _iterator;

  SkippingStringSplitter(
    this._string,
    this._separator, [
    Set<Delimiters> delimitersSet = const {},
  ]) : _iterator = SkippingIterator(_string, delimitersSet);

  List<String> splits() {
    final indexes = _findsIndexesOfSeparator();

    return _chopString(indexes);
  }

  List<int> _findsIndexesOfSeparator() {
    final result = <int>[];
    _iterator.forEach((char) {
      if (char == _separator) result.add(_iterator.currentIndex);
    });
    return result;
  }

  List<String> _chopString(List<int> indexes) {
    return StringChopper(_string)
        .chopsAt(indexes, excludingIndexes: true)
        .withoutEmptyStrings();
  }

  void skipAreasDelimitedBy(Set<Delimiters> delimiters) =>
      _iterator.skippingWithin(delimiters);

  void splitWith(String separator) => _separator = separator;
}
