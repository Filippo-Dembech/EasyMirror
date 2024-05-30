import 'package:easy_mirror/src/method_analyzer/skip_bound_splitter/string_chopper.dart';
import 'package:test/test.dart';

void main() {
  test("StringChopper empty string", () {
    expect(StringChopper("").chopsAt(Included([])), equals([]));
    expect(StringChopper("").chopsAt(Included([0])), equals([]));
    expect(StringChopper("").chopsAt(Included([0, 2, 3])), equals([]));

    expect(StringChopper("").chopsAt(Excluded([])), equals([]));
    expect(StringChopper("").chopsAt(Excluded([0])), equals([]));
    expect(StringChopper("").chopsAt(Excluded([0, 2, 3])), equals([]));
  });

  test("StringChopper with string", () {
    expect(StringChopper("a").chopsAt(Included([0])), equals(["a"]));
    expect(StringChopper("a").chopsAt(Excluded([0])), equals([]));

    expect(StringChopper("ab").chopsAt(Included([0, 1])), equals(["a", "b"]));
    expect(StringChopper("ab").chopsAt(Excluded([0, 1])), equals([]));

    expect(StringChopper("abc").chopsAt(Included([0, 1, 2])), equals(["a", "b", "c"]));
    expect(StringChopper("abc").chopsAt(Excluded([0, 1, 2])), equals([]));

    expect(StringChopper("abcd").chopsAt(Included([0, 1, 2, 3])), equals(["a", "b", "c", "d"]));
    expect(StringChopper("abcd").chopsAt(Excluded([0, 1, 2, 3])), equals([]));

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

  testAfter("h", index: 0 , equalsTo: "");
  testBefore("h", index: 0, equalsTo: "");
  testAfter("h", index: 0, takeIndexIn: true, equalsTo: "h");
  testBefore("h", index: 0, takeIndexIn: true, equalsTo: "h");
  
  testAfter("hi there", index: 2, equalsTo: "there");
  testAfter("hi there", index: 2, takeIndexIn: true, equalsTo: " there");

  testBefore("hi there", index: 2, equalsTo: "hi");
  testBefore("hi there", index: 2, takeIndexIn: true, equalsTo: "hi ");

  testAfter("hi there", index: 0, equalsTo: "i there");
  testBefore("hi there", index: 0, equalsTo: "");
  testAfter("hi there", index: 0, takeIndexIn: true, equalsTo: "hi there");
  testBefore("hi there", index: 0, takeIndexIn: true, equalsTo: "h");

  testAfter("hi there", index: 7, equalsTo: "");
  testBefore("hi there", index: 7, equalsTo: "hi ther");
  testAfter("hi there", index: 7, takeIndexIn: true, equalsTo: "e");
  testBefore("hi there", index: 7, takeIndexIn: true, equalsTo: "hi there");

  testAfter("sample string", index: 2, equalsTo: "ple string");
  testAfter("sample string", index: 2, takeIndexIn: true, equalsTo: "mple string");
  testAfter("sample string", index: 0, equalsTo: "ample string");
  testAfter("sample string", index: 0, takeIndexIn: true, equalsTo: "sample string");
  testAfter("sample string", index: 12, equalsTo: "");
  testAfter("sample string", index: 12, takeIndexIn: true, equalsTo: "g");

  testBefore("a", index: 0, equalsTo: "");
  testBefore("a", index: 0, takeIndexIn: true, equalsTo: "a");
  testBefore("sample string", index: 2, equalsTo: "sa");
  testBefore("sample string", index: 2, takeIndexIn: true, equalsTo: "sam");
  testBefore("sample string", index: 0, equalsTo: "");
  testBefore("sample string", index: 0, takeIndexIn: true, equalsTo: "s");
  testBefore("sample string", index: 12, equalsTo: "sample strin");
  testBefore("sample string", index: 12, takeIndexIn: true, equalsTo: "sample string");

  test("StringChopper after() and before() exceptions", () {
    expect(() => StringChopper("").after(2), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("").before(2), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("").after(0), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("").before(0), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("hi there").after(20), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("hi there").before(20), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("hi there").after(8), throwsA(isA<ChoppingException>()));
    expect(() => StringChopper("hi there").before(8), throwsA(isA<ChoppingException>()));
  });
}


void testAfter(String text, {required int index, required String equalsTo, bool takeIndexIn = false}) {
  if (takeIndexIn) {
    test("'$text' after including index $index", () {
      expect(StringChopper(text).after(index, includeIndex: takeIndexIn), equals(equalsTo));
    });
  } else {
    test("'$text' after index $index", () {
      expect(StringChopper(text).after(index, includeIndex: takeIndexIn), equals(equalsTo));
    });
  }
}

void testBefore(String text, {required int index, required String equalsTo, bool takeIndexIn = false}) {
  if (takeIndexIn) {
    test("'$text' before including index $index", () {
      expect(StringChopper(text).before(index, includeIndex: takeIndexIn), equals(equalsTo));
    });
  } else {
    test("'$text' before index $index", () {
      expect(StringChopper(text).before(index, includeIndex: takeIndexIn), equals(equalsTo));
    });
  }
}