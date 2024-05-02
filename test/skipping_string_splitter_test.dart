import 'package:easy_mirror/src/method_analyzer/string_splitter/skipping_string_splitter.dart';
import 'package:test/test.dart';

void main() {
  test("StringSplitter with no delimiters", () {
    expect(SkippingStringSplitter("hi, there", ",").splits(),equals(["hi", " there"]));
  });
}
