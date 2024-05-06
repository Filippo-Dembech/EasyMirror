import 'package:easy_mirror/easy_mirror.dart';
import 'package:test/test.dart';

void main() {

  test("is opening delimiter?", () {
    expect(Delimiters.isOpeningDelimiter("("), isTrue);
    expect(Delimiters.isOpeningDelimiter("["), isTrue);
    expect(Delimiters.isOpeningDelimiter("{"), isTrue);
    expect(Delimiters.isOpeningDelimiter("<"), isTrue);

    expect(Delimiters.isOpeningDelimiter(")"), isFalse);
    expect(Delimiters.isOpeningDelimiter("]"), isFalse);
    expect(Delimiters.isOpeningDelimiter("}"), isFalse);
    expect(Delimiters.isOpeningDelimiter(">"), isFalse);

    expect(Delimiters.isOpeningDelimiter("a"), isFalse);
  });


  test("is closing delimiter?", () {
    expect(Delimiters.isClosingDelimiter(")"), isTrue);
    expect(Delimiters.isClosingDelimiter("]"), isTrue);
    expect(Delimiters.isClosingDelimiter("}"), isTrue);
    expect(Delimiters.isClosingDelimiter(">"), isTrue);

    expect(Delimiters.isClosingDelimiter("("), isFalse);
    expect(Delimiters.isClosingDelimiter("["), isFalse);
    expect(Delimiters.isClosingDelimiter("{"), isFalse);
    expect(Delimiters.isClosingDelimiter("<"), isFalse);

    expect(Delimiters.isClosingDelimiter("a"), isFalse);
  });


  test("from string to delimiters", () {
    expect(Delimiters.of(")"), equals(Delimiters.ROUND_BRACKETS));
    expect(Delimiters.of("]"), equals(Delimiters.SQUARED_BRACKETS));
    expect(Delimiters.of("}"), equals(Delimiters.CURLY_BRACKETS));
    expect(Delimiters.of(">"), equals(Delimiters.DIAMOND_BRACKETS));

    expect(Delimiters.of("("), equals(Delimiters.ROUND_BRACKETS));
    expect(Delimiters.of("["), equals(Delimiters.SQUARED_BRACKETS));
    expect(Delimiters.of("{"), equals(Delimiters.CURLY_BRACKETS));
    expect(Delimiters.of("<"), equals(Delimiters.DIAMOND_BRACKETS));
  });

  test("allMatches without text", () {
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, ""), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "()"), equals([(0,1)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "()()"), equals([(0,1), (2,3)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(())"), equals([(0,3), (1,2)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(()())"), equals([(0,5), (1,2), (3,4)]));

  });

  test("allMatches with short text", () {
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "a"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(a)"), equals([(0,2)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(a)(b)"), equals([(0,2), (3,5)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((a))"), equals([(0,4), (1,3)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((a)(b))"), equals([(0,7), (1,3), (4,6)]));
  });

  test("allMatches with long text", () {
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "abc"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(abc)"), equals([(0,4)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(abc)(def)"), equals([(0,4), (5,9)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((abc))"), equals([(0,6), (1,5)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((abc)(def))"), equals([(0,11), (1,5), (6,10)]));
  });

  test("matches with unmatching delimiters", () {
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "("), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, ")"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(("), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "))"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(()"), equals([(1,2)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "()))"), equals([(0,1)]));

    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(a"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "a)"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((a"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "a))"), equals([]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "((a)"), equals([(1,3)]));
    expect(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(a)))"), equals([(0,2)]));
  });
}