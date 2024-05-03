import '../extensions/list__empty_string_remover.dart';
import '../string_extractor/delimiters.dart';
import 'string_chopper.dart';
import 'jumping_iterator.dart';

class SkippingStringSplitter {
  final String _string;
  final String separator;
  final JumpingIterator _iterator;

  SkippingStringSplitter(
    this._string,
    {required this.separator}) : _iterator = JumpingIterator(_string, {});

  List<String> splits() {
    final indexes = _findsIndexesOfSeparator();

    return _chopString(indexes);
  }

  List<int> _findsIndexesOfSeparator() {
    final result = <int>[];
      // ! When 'next' is called in the '.forEach()' the index shift
      // ! by one, so the index within the '.forEach()' doesn't refer
      // ! to the current character.
    _iterator.forEach((char, index) {
      if (char == separator) result.add(index);
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

}
