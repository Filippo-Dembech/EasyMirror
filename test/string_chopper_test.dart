import 'package:easy_mirror/src/method_analyzer/skip_bound_splitter/string_chopper.dart';
import 'package:test/test.dart';

void main() {
  test("StringChopper empty string", () {
    expect(StringChopper("").chopsAt(Included([])), equals([""]));
    expect(StringChopper("").chopsAt(Included([0])), equals([""]));
    expect(StringChopper("").chopsAt(Included([0, 2, 3])), equals([""]));

    expect(StringChopper("").chopsAt(Excluded([])), equals([""]));
    expect(StringChopper("").chopsAt(Excluded([0])), equals([""]));
    expect(StringChopper("").chopsAt(Excluded([0, 2, 3])), equals([""]));
  });

  test("StringChopper with string", () {
    expect(StringChopper("hi there mate!").chopsAt(Included([])), equals(["hi there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([0])), equals(["hi there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([1])), equals(["h", "i there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([2])), equals(["hi", " there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([3])), equals(["hi ", "there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([14])), equals(["hi there mate!"]));

    expect(StringChopper("hi there mate!").chopsAt(Excluded([])), equals(["hi there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Excluded([0])), equals(["i there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Excluded([1])), equals(["h", " there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Excluded([2])), equals(["hi", "there mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Excluded([3])), equals(["hi ", "here mate!"]));
    expect(StringChopper("hi there mate!").chopsAt(Included([14])), equals(["hi there mate!"]));
  });

  test("StringChopper with multiple equal indexes", () {
    expect(StringChopper("hi there").chopsAt(Included([0, 0, 0])), equals(["hi there"]));
    expect(StringChopper("hi there").chopsAt(Included([1, 1, 1])), equals(["h", "i there"]));
    expect(StringChopper("hi there").chopsAt(Included([2, 2, 2])), equals(["hi", " there"]));
    expect(StringChopper("hi there").chopsAt(Included([7, 7, 7])), equals(["hi ther", "e"]));

    expect(StringChopper("hi there").chopsAt(Included([0, 0, 1])), equals(["h", "i there"]));
    expect(StringChopper("hi there").chopsAt(Included([3, 3, 4])), equals(["hi ", "t", "here"]));
    expect(StringChopper("hi there").chopsAt(Included([3, 7, 7])), equals(["hi ", "ther", "e"]));
  });

  test("StringChopper with unordered indexes", () {
    expect(() => StringChopper("hi there").chopsAt(Included([3, 2, 1])), throwsA(isA<UnsortedIndexesException>()));
    expect(() => StringChopper("hi there").chopsAt(Included([1, 3, 2])), throwsA(isA<UnsortedIndexesException>()));
    expect(() => StringChopper("hi there").chopsAt(Included([1, 3, 2])), throwsA(isA<UnsortedIndexesException>()));
    expect(() => StringChopper("hi there").chopsAt(Included([1, 2, 1])), throwsA(isA<UnsortedIndexesException>()));
    expect(() => StringChopper("hi there").chopsAt(Included([3, 2, 1])), throwsA(isA<UnsortedIndexesException>()));
  });
}
