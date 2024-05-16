import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {

  test("edge cases with PluckExtraction strategy", () {
    expect(StringExtractor.parsing("").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("a").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("ab").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("abc").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("()").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([""]));
    expect(StringExtractor.parsing("() a => (\"\", 0)").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["", "\"\", 0"]));
    expect(StringExtractor.parsing("(a)").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["a"]));
  });

  test("edge cases with ViseExtraction strategy", () {
    expect(StringExtractor.parsing("").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("a").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("ab").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("abc").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("()").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([""]));
    expect(StringExtractor.parsing("(a)").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["a"]));
  });

  test("normal extraction with PluckExtraction strategy", () {
    expect(StringExtractor.parsing("(hi) there").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi"]));
    expect(StringExtractor.parsing("(hi) there (mate)").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi", "mate"]));
  });

  test("normal extraction with ViseExtraction strategy", () {
    expect(StringExtractor.parsing("(hi) there").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi"]));
    expect(StringExtractor.parsing("(hi) there (mate)").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi) there (mate"]));
  });

  test("unmatching extraction with PluckExtraction strategy", () {
    expect(StringExtractor.parsing("(hi there").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("(hi there (mate)").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["mate"]));
    expect(StringExtractor.parsing("(hi there (mate").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
  });

  test("unmatching extraction with ViseExtraction strategy", () {
    expect(StringExtractor.parsing("(hi there").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
    expect(StringExtractor.parsing("(hi there (mate)").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi there (mate"]));
    expect(StringExtractor.parsing("(hi there (mate").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals([]));
  });

  test("nested extraction with PluckExtraction strategy", () {
    expect(StringExtractor.parsing("((hi)) there").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["(hi)", "hi"]));
    expect(StringExtractor.parsing("(((hi))) there").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["((hi))", "(hi)", "hi"]));
    expect(StringExtractor.parsing("(((hi))) (((there)))").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["((hi))", "(hi)", "hi", "((there))", "(there)", "there"]));
    expect(StringExtractor.parsing("(((hi)))(((there)))").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["((hi))", "(hi)", "hi", "((there))", "(there)", "there"]));
    expect(StringExtractor.parsing("((hi) there)").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["(hi) there", "hi"]));
  });

  test("nested extraction with ViseExtraction strategy", () {
    expect(StringExtractor.parsing("(hi) there").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi"]));
    expect(StringExtractor.parsing("(hi) there (mate)").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(["hi) there (mate"]));
  });
}






