import 'dart:io';
import 'jumping_iterator.dart';
import 'skipping_string_splitter.dart';
import '../String Extractor/delimiters.dart';

void p(String string, [Set<Delimiters> delimiters = const {}]) {
  stdout.write("'");

  final iterator = JumpingIterator(string, delimiters);
  while (iterator.hasNext) {
    stdout.write(iterator.next);
  }
  stdout.write("'");
  print("");

}

void main() {

  p("hello, (mate)");  // "hello, (mate)"
  p("hello, (mate)", {Delimiters.ROUND_BRACKETS});  // "hello, "
  p("{where} (are, you?) [mate!]"); // "{where} (are, you?) [mate!]"
  p("{where} (are, you?) [mate!]", {Delimiters.ROUND_BRACKETS}); // "{where}  [mate!]"
  p("{where} (are, you?) [mate!]", {Delimiters.ROUND_BRACKETS, Delimiters.SQUARED_BRACKETS}); // "{where}  "
  p("{where} (are, you?) [mate!]", {Delimiters.ROUND_BRACKETS, Delimiters.SQUARED_BRACKETS, Delimiters.CURLY_BRACKETS}); // "  "
  p("{where (are, you?) [mate!]", {Delimiters.ROUND_BRACKETS, Delimiters.SQUARED_BRACKETS, Delimiters.CURLY_BRACKETS}); // "  "
  p("{where} are, you?) [mate!]", {Delimiters.ROUND_BRACKETS, Delimiters.SQUARED_BRACKETS, Delimiters.CURLY_BRACKETS}); // "  "
  p("{where} (are, you?) [mate!", {Delimiters.ROUND_BRACKETS, Delimiters.SQUARED_BRACKETS, Delimiters.CURLY_BRACKETS}); // "  "

  /*
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
  */
}

void splitPrint(List<String> list) {
  print("${list.toString().padRight(20)} -> length: ${list.length}");
}
