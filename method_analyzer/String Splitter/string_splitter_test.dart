import '../String Extractor/delimiters.dart';
import 'delimiters_iterator.dart';
import 'string_splitter.dart';

void main() {
  final iterator = DelimitedIterator("(<hi>i(there", [Delimiters.DIAMOND_BRACKETS, Delimiters.ROUND_BRACKETS]);
  while (iterator.hasNext) {
    print(iterator.next);
  }
  /*
  String testingString =
      "(Map<String, int> addresses, (String?, Generic<int>) person, Function(int, int?) calculation)";
  StringSplitter splitter = StringSplitter.splits(testingString)
      ..withSeparator(",")
      ..ignoringWithin([Delimiters.DIAMOND_BRACKETS, Delimiters.ROUND_BRACKETS]);
  print(splitter.split());
   */
}
