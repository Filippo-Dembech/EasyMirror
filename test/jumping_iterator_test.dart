import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

String iterateOver(String string, [Set<Delimiters> delimiters = const {}]) {
  String result = "";
  final iterator = JumpingIterator(string, delimiters);
  iterator.forEach((char, index) => result += char);
  return result;
}

void main() {
  test("JumpingIterator with no delimiters set", () {
    expect(iterateOver(""), equals(""));
    expect(iterateOver("hi"), equals("hi"));
    expect(iterateOver("hi there"), equals("hi there"));

    expect(iterateOver("(hi)"), equals("(hi)"));
    expect(iterateOver("<hi>"), equals("<hi>"));
    expect(iterateOver("{hi}"), equals("{hi}"));
    expect(iterateOver("[hi]"), equals("[hi]"));

    expect(iterateOver("()"), equals("()"));
    expect(iterateOver("<>"), equals("<>"));
    expect(iterateOver("{}"), equals("{}"));
    expect(iterateOver("[]"), equals("[]"));
  });

  test("JumpIterator with matching round delimiters", () {
    expect(iterateOver("(hi)", {Delimiters.ROUND_BRACKETS}), equals(""));
    expect(iterateOver("()", {Delimiters.ROUND_BRACKETS}), equals(""));
    expect(iterateOver("(hi) there", {Delimiters.ROUND_BRACKETS}),
        equals(" there"));
    expect(
        iterateOver("(hi) (there)", {Delimiters.ROUND_BRACKETS}), equals(" "));
    expect(iterateOver("((hi))", {Delimiters.ROUND_BRACKETS}), equals(""));
    expect(iterateOver("(((hi)))", {Delimiters.ROUND_BRACKETS}), equals(""));
  });

  test("JumpingIterator with unmatching round delimiters", () {
    expect(iterateOver("(", {Delimiters.ROUND_BRACKETS}), equals("("));
    expect(iterateOver(")", {Delimiters.ROUND_BRACKETS}), equals(")"));
    expect(iterateOver("((hi)", {Delimiters.ROUND_BRACKETS}), equals("("));
    expect(iterateOver("(hi))", {Delimiters.ROUND_BRACKETS}), equals(")"));
    expect(iterateOver("(()", {Delimiters.ROUND_BRACKETS}), equals("("));
    expect(iterateOver("((", {Delimiters.ROUND_BRACKETS}), equals("(("));
    expect(iterateOver("))", {Delimiters.ROUND_BRACKETS}), equals("))"));
    expect(iterateOver("(((", {Delimiters.ROUND_BRACKETS}), equals("((("));
    expect(iterateOver(")))", {Delimiters.ROUND_BRACKETS}), equals(")))"));
    expect(iterateOver("(hi) ((there", {Delimiters.ROUND_BRACKETS}),
        equals(" ((there"));
    expect(iterateOver("(hi ((there", {Delimiters.ROUND_BRACKETS}),
        equals("(hi ((there"));
    expect(iterateOver("(hi ((there)", {Delimiters.ROUND_BRACKETS}),
        equals("(hi ("));
    expect(iterateOver("(hi ((t)he)r)e)", {Delimiters.ROUND_BRACKETS}),
        equals("e)"));
    expect(iterateOver("(hi) ((t)he)r)e)", {Delimiters.ROUND_BRACKETS}),
        equals(" r)e)"));
  });

  test("JumpingIterator with mixed matching delimiters", () {
    expect(
        iterateOver("()[]{}<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("() [] {} <>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("   "));
    expect(
        iterateOver("()hi[]there{}mate<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("hitheremate"));
    expect(
        iterateOver("(hi)there[] mate{}<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("there mate"));
    expect(
        iterateOver("(hi)[there]{mate}<!!!>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("((hi))[]{}<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("(())hi[[there]]{{mate}}<<>how>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("hi"));
    expect(
        iterateOver("<()[]{}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("<(hi)[there]{mate}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("<()hi[]there{}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(""));
    expect(
        iterateOver("where<()hi[]there{}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("where"));
  });

  test("JumpingIterator with mixed unmatching delimiters", () {
    expect(
        iterateOver("([]{}<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("("));
    expect(
        iterateOver("([{}<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("(["));
    expect(
        iterateOver("([{<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("([{"));
    expect(
        iterateOver("([]{<>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("({"));
    expect(
        iterateOver("([]{<>>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("({>"));
    expect(
        iterateOver("([]{}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("(>"));
    expect(
        iterateOver(")]}>", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals(")]}>"));
    expect(
        iterateOver("<()hi[]there{}", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("<hithere"));
    expect(
        iterateOver("<() hi []there{mate}", {
          Delimiters.ROUND_BRACKETS,
          Delimiters.SQUARED_BRACKETS,
          Delimiters.CURLY_BRACKETS,
          Delimiters.DIAMOND_BRACKETS
        }),
        equals("< hi there"));
  });
}
