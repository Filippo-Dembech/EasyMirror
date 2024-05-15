import 'package:easy_mirror/easy_mirror.dart';
import 'package:easy_mirror/src/method_analyzer/skip_bound_splitter/skip_bound_splitter.dart';
import 'package:test/test.dart';

void main() {
  test("invalid separator", () {
    expect(() => SkipBoundSplitter("", separator: "ab"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkipBoundSplitter("", separator: "abc"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkipBoundSplitter("abc", separator: "ab"), throwsA(isA<InvalidSeparatorException>()));
    expect(() => SkipBoundSplitter("abcd", separator: "abc"), throwsA(isA<InvalidSeparatorException>()));
  });

  test("edge cases", () {
    expect(SkipBoundSplitter("", separator: "").splits(), equals([]));
    expect(SkipBoundSplitter("", separator: ",").splits(), equals([]));
    expect(SkipBoundSplitter("a", separator: ",").splits(), equals(["a"]));
    expect(SkipBoundSplitter(",", separator: ",").splits(), equals([]));
    expect(SkipBoundSplitter(",,,", separator: ",").splits(), equals([]));
    expect(SkipBoundSplitter(",a,", separator: ",").splits(), equals(["a"]));
    expect(SkipBoundSplitter(",a", separator: ",").splits(), equals(["a"]));
    expect(SkipBoundSplitter("a,", separator: ",").splits(), equals(["a"]));
    expect(SkipBoundSplitter(",a,b,", separator: ",").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter("a,b,", separator: ",").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter(",a,b", separator: ",").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter(",ab,", separator: ",").splits(), equals(["ab"]));


    expect(SkipBoundSplitter("", separator: "").splits(), equals([]));
    expect(SkipBoundSplitter("", separator: ";").splits(), equals([]));
    expect(SkipBoundSplitter("a", separator: ";").splits(), equals(["a"]));
    expect(SkipBoundSplitter(";", separator: ";").splits(), equals([]));
    expect(SkipBoundSplitter(";;;", separator: ";").splits(), equals([]));
    expect(SkipBoundSplitter(";a;", separator: ";").splits(), equals(["a"]));
    expect(SkipBoundSplitter(";a", separator: ";").splits(), equals(["a"]));
    expect(SkipBoundSplitter("a;", separator: ";").splits(), equals(["a"]));
    expect(SkipBoundSplitter(";a;b;", separator: ";").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter("a;b;", separator: ";").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter(";a;b", separator: ";").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter(";ab;", separator: ";").splits(), equals(["ab"]));
  });

  test("no delimiters", () {
    expect(SkipBoundSplitter("a,b", separator: ",").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter("a,b,c", separator: ",").splits(), equals(["a", "b", "c"]));
    expect(SkipBoundSplitter("ab,cd", separator: ",").splits(), equals(["ab", "cd"]));
    expect(SkipBoundSplitter("ab,cd,ef", separator: ",").splits(), equals(["ab", "cd", "ef"]));

    expect(SkipBoundSplitter("a;b", separator: ";").splits(), equals(["a", "b"]));
    expect(SkipBoundSplitter("a;b;c", separator: ";").splits(), equals(["a", "b", "c"]));
    expect(SkipBoundSplitter("ab;cd", separator: ";").splits(), equals(["ab", "cd"]));
    expect(SkipBoundSplitter("ab;cd;ef", separator: ";").splits(), equals(["ab", "cd", "ef"]));


    expect(SkipBoundSplitter("abc", separator: "a").splits(), equals(["bc"]));
    expect(SkipBoundSplitter("abc", separator: "b").splits(), equals(["a", "c"]));
    expect(SkipBoundSplitter("abc", separator: "c").splits(), equals(["ab"]));
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
  final splitter = SkipBoundSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitSquared({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.SQUARED_BRACKETS},
}) {
  final splitter = SkipBoundSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitCurly({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.CURLY_BRACKETS},
}) {
  final splitter = SkipBoundSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}

List<String> splitDiamond({
  required String string,
  required String separator,
  Set<Delimiters> delimiters = const {Delimiters.DIAMOND_BRACKETS},
}) {
  final splitter = SkipBoundSplitter(string, separator: separator)..ignoringSeparatorsWithin(delimiters);
  return splitter.splits();
}
