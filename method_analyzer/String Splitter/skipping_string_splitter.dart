import '../Extensions/list__empty_string_remover.dart';
import '../String Extractor/delimiters.dart';
import 'string_chopper.dart';
import 'jumping_iterator.dart';

class SkippingStringSplitter {
  final String _string;
  String _separator;
  final JumpingIterator _iterator;

  SkippingStringSplitter(
    this._string,
    this._separator, [
    Set<Delimiters> delimitersSet = const {},
  ]) : _iterator = JumpingIterator(_string, delimitersSet);

  List<String> splits() {
    final indexes = _findsIndexesOfSeparator();

    return _chopString(indexes);
  }

  List<int> _findsIndexesOfSeparator() {
    final result = <int>[];
      // ! When 'next' is called in the '.forEach()' the index shift
      // ! by one, so the index within the '.forEach()' doesn't refer
      // ! to the current character.
    _iterator.forEach((char) {
      if (char == _separator) result.add(_iterator.currentIndex - 1);
    });
    return result;
  }

  List<String> _chopString(List<int> indexes) {
    return StringChopper(_string)
        .chopsAt(Excluded(indexes))
        .withoutEmptyStrings();
  }

  void skipAreasDelimitedBy(Set<Delimiters> delimiters) =>
      _iterator.jump(delimiters);

  void splitWith(String separator) => _separator = separator;
}
