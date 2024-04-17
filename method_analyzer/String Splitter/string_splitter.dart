import '../Extensions/object__equal_objects.dart';
import '../Extensions/string__element_fetcher.dart';
import '../String Extractor/delimiters.dart';

class StringSplitter {
  String _string;
  String _separator = "";
  List<Delimiters> _delimitersPairs = [];

  StringSplitter.splits(this._string);

  List<String> split() {
    return []; // TODO
  }


  void withSeparator(String newSeparator) {
    _separator = newSeparator;
  }

  void ignoringWithin(List<Delimiters> newDelimitersPairs) {
    _delimitersPairs = newDelimitersPairs;
  }

}
