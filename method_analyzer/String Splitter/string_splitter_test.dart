import '../Extensions/list__empty_string_remover.dart';
import 'string_chopper.dart';
import '../String Extractor/delimiters.dart';
import 'skipping_iterator.dart';


void main() {
  splitPrint(SkippingStringSplitter("hi, there", ",").splits());
  splitPrint(SkippingStringSplitter(
      "hi, (there, mate)", ",", {Delimiters.ROUND_BRACKETS}).splits());
  splitPrint(SkippingStringSplitter(
      "Map<String, int> addresses, Function(String, int) operation",
      ",",
      {Delimiters.DIAMOND_BRACKETS, Delimiters.ROUND_BRACKETS}).splits());
  splitPrint(SkippingStringSplitter(
      "(My name is: Ninfadora), (hi, my name is james), {sorry, who?}",
      ",",
      {Delimiters.ROUND_BRACKETS, Delimiters.CURLY_BRACKETS}).splits());
  splitPrint(SkippingStringSplitter(
      "(harry, potter) { hermione, granger} [ ron, weasley], (draco, malfoy), [tiger, goyle],,, {parcy, park,inson}",
      ",", {
    Delimiters.ROUND_BRACKETS,
    Delimiters.SQUARED_BRACKETS,
    Delimiters.CURLY_BRACKETS
  }).splits());
}

void splitPrint(List<String> list) {
  print("${list.toString().padRight(20)} -> length: ${list.length}");
}
