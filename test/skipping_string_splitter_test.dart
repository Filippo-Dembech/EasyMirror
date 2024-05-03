import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {
  test("invalid separator", () {
    expect(() => SkippingStringSplitter("", separator: "ab"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkippingStringSplitter("", separator: "abc"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkippingStringSplitter("abc", separator: "ab"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkippingStringSplitter("abcd", separator: "abc"), throwsA(isA<InvalidSeparatorException>()));
  });

  test("edge cases", () {
    expect(SkippingStringSplitter("", separator: "").splits(), equals([]));
    expect(SkippingStringSplitter("", separator: ",").splits(), equals([]));
    expect(SkippingStringSplitter("a", separator: ",").splits(), equals(["a"]));
    expect(SkippingStringSplitter(",", separator: ",").splits(), equals([]));
    expect(SkippingStringSplitter(",,,", separator: ",").splits(), equals([]));
    expect(SkippingStringSplitter(",a,", separator: ",").splits(), equals(["a"]));
    expect(SkippingStringSplitter(",a", separator: ",").splits(), equals(["a"]));
    expect(SkippingStringSplitter("a,", separator: ",").splits(), equals(["a"]));
    expect(SkippingStringSplitter(",a,b,", separator: ",").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter("a,b,", separator: ",").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter(",a,b", separator: ",").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter(",ab,", separator: ",").splits(), equals(["ab"]));


    expect(SkippingStringSplitter("", separator: "").splits(), equals([]));
    expect(SkippingStringSplitter("", separator: ";").splits(), equals([]));
    expect(SkippingStringSplitter("a", separator: ";").splits(), equals(["a"]));
    expect(SkippingStringSplitter(";", separator: ";").splits(), equals([]));
    expect(SkippingStringSplitter(";;;", separator: ";").splits(), equals([]));
    expect(SkippingStringSplitter(";a;", separator: ";").splits(), equals(["a"]));
    expect(SkippingStringSplitter(";a", separator: ";").splits(), equals(["a"]));
    expect(SkippingStringSplitter("a;", separator: ";").splits(), equals(["a"]));
    expect(SkippingStringSplitter(";a;b;", separator: ";").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter("a;b;", separator: ";").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter(";a;b", separator: ";").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter(";ab;", separator: ";").splits(), equals(["ab"]));
  });

  test("no delimiters", () {
    expect(SkippingStringSplitter("a,b", separator: ",").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter("a,b,c", separator: ",").splits(), equals(["a", "b", "c"]));
    expect(SkippingStringSplitter("ab,cd", separator: ",").splits(), equals(["ab", "cd"]));
    expect(SkippingStringSplitter("ab,cd,ef", separator: ",").splits(), equals(["ab", "cd", "ef"]));

    expect(SkippingStringSplitter("a;b", separator: ";").splits(), equals(["a", "b"]));
    expect(SkippingStringSplitter("a;b;c", separator: ";").splits(), equals(["a", "b", "c"]));
    expect(SkippingStringSplitter("ab;cd", separator: ";").splits(), equals(["ab", "cd"]));
    expect(SkippingStringSplitter("ab;cd;ef", separator: ";").splits(), equals(["ab", "cd", "ef"]));


    expect(SkippingStringSplitter("abc", separator: "a").splits(), equals(["bc"]));
    expect(SkippingStringSplitter("abc", separator: "b").splits(), equals(["a", "c"]));
    expect(SkippingStringSplitter("abc", separator: "c").splits(), equals(["ab"]));
  });

  test("with matching delimiters", () {
    expect(splitRound(string: "", separator: ""), equals([]));
    expect(splitRound(string: "", separator: ","), equals([]));

    expect(splitRound(string: "()", separator: ""), equals(["()"]));
    expect(splitRound(string: "()", separator: ","), equals(["()"]));

    expect(splitRound(string: "(),()", separator: ","), equals(["()", "()"]));
    expect(splitRound(string: "(,),()", separator: ","), equals(["(,)", "()"]));
    expect(splitRound(string: "(),(,)", separator: ","), equals(["()", "(,)"]));
    expect(splitRound(string: "(,),(,)", separator: ","), equals(["(,)", "(,)"]));
    expect(splitRound(string: "(,,),(,,)", separator: ","), equals(["(,,)", "(,,)"]));
    expect(splitRound(string: "((,,)),((,,))", separator: ","), equals(["((,,))", "((,,))"]));
    expect(splitRound(string: "((,,),(,,))", separator: ","), equals(["((,,),(,,))"]));
  }); 

  test("with unmatching delimiters", () {
    expect(splitRound(string: "(", separator: ""), equals(["("]));
    expect(splitRound(string: ")", separator: ""), equals([")"]));

    expect(splitRound(string: "(", separator: ","), equals(["("]));
    expect(splitRound(string: ")", separator: ","), equals([")"]));

    expect(splitRound(string: "((", separator: ""), equals(["(("]));
    expect(splitRound(string: "))", separator: ""), equals(["))"]));
    expect(splitRound(string: "((", separator: ","), equals(["(("]));
    expect(splitRound(string: "))", separator: ","), equals(["))"]));


    expect(splitRound(string: "())", separator: ""), equals(["())"]));
    expect(splitRound(string: "(()", separator: ""), equals(["(()"]));
    expect(splitRound(string: "())", separator: ","), equals(["())"]));
    expect(splitRound(string: "(()", separator: ","), equals(["(()"]));


    expect(splitRound(string: "(,))", separator: ""), equals(["(,))"]));
    expect(splitRound(string: "((,)", separator: ""), equals(["((,)"]));
    expect(splitRound(string: "(,))", separator: ","), equals(["(,))"]));
    expect(splitRound(string: "((,)", separator: ","), equals(["((,)"]));

    expect(splitRound(string: "(,),)", separator: ""), equals(["(,),)"]));
    expect(splitRound(string: "(,(,)", separator: ""), equals(["(,(,)"]));
    expect(splitRound(string: "(,),)", separator: ","), equals(["(,)", ")"]));
    expect(splitRound(string: "(,(,)", separator: ","), equals(["(", "(,)"]));

    expect(splitRound(string: "(,", separator: ","), equals(["("]));
    expect(splitRound(string: "),", separator: ","), equals([")"]));
    expect(splitRound(string: ",(", separator: ","), equals(["("]));
    expect(splitRound(string: ",)", separator: ","), equals([")"]));
    expect(splitRound(string: ",(,", separator: ","), equals(["("]));
    expect(splitRound(string: ",),", separator: ","), equals([")"]));

    expect(splitRound(string: "),)", separator: ","), equals([")", ")"]));
    expect(splitRound(string: "(,(", separator: ","), equals(["(", "("]));

    ///
    expect(splitRound(string: "(()", separator: ""), equals(["(()"]));
    expect(splitRound(string: "())", separator: ""), equals(["())"]));

    expect(splitRound(string: "(()", separator: ","), equals(["(()"]));
    expect(splitRound(string: "())", separator: ","), equals(["())"]));

    expect(splitRound(string: "((()", separator: ""), equals(["((()"]));
    expect(splitRound(string: "()))", separator: ""), equals(["()))"]));
    expect(splitRound(string: "((()", separator: ","), equals(["((()"]));
    expect(splitRound(string: "()))", separator: ","), equals(["()))"]));


    expect(splitRound(string: "(()))", separator: ""), equals(["(()))"]));
    expect(splitRound(string: "((())", separator: ""), equals(["((())"]));
    expect(splitRound(string: "(()))", separator: ","), equals(["(()))"]));
    expect(splitRound(string: "((())", separator: ","), equals(["((())"]));


    expect(splitRound(string: "((,)))", separator: ""), equals(["((,)))"]));
    expect(splitRound(string: "(((,))", separator: ""), equals(["(((,))"]));
    expect(splitRound(string: "((,)))", separator: ","), equals(["((,)))"]));
    expect(splitRound(string: "(((,))", separator: ","), equals(["(((,))"]));

    expect(splitRound(string: "((,),))", separator: ""), equals(["((,),))"]));
    expect(splitRound(string: "((,(,))", separator: ""), equals(["((,(,))"]));
    expect(splitRound(string: "((,),))", separator: ","), equals(["((,),))"]));
    expect(splitRound(string: "((,(,))", separator: ","), equals(["((,(,))"]));

    expect(splitRound(string: "((,)", separator: ","), equals(["((,)"]));
    expect(splitRound(string: "(),)", separator: ","), equals(["()", ")"]));
    expect(splitRound(string: "(,()", separator: ","), equals(["(", "()"]));
    expect(splitRound(string: "(,))", separator: ","), equals(["(,))"]));
    expect(splitRound(string: "(,(,)", separator: ","), equals(["(", "(,)"]));
    expect(splitRound(string: "(,),)", separator: ","), equals(["(,)", ")"]));

    expect(splitRound(string: "(),))", separator: ","), equals(["()", "))"]));
    expect(splitRound(string: "((,()", separator: ","), equals(["((", "()"]));
  });
}

List<String> splitRound({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.ROUND_BRACKETS},
}) {
  final splitter = SkippingStringSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitSquared({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.SQUARED_BRACKETS},
}) {
  final splitter = SkippingStringSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitCurly({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.CURLY_BRACKETS},
}) {
  final splitter = SkippingStringSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitDiamond({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.DIAMOND_BRACKETS},
}) {
  final splitter = SkippingStringSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}
