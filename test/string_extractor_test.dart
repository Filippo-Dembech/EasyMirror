import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {

  test("edge cases with MatchingDelimitersExtraction strategy", () {
    expect(StringExtractor.parsing("").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(""));
    expect(StringExtractor.parsing("()").extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(""));
  });

  test("edge cases with ViseExtraction strategy", () {
    expect(StringExtractor.parsing("").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(""));
    expect(StringExtractor.parsing("()").using(ViseExtraction()).extractsStringWithin(Delimiters.ROUND_BRACKETS), equals(""));
  });

}