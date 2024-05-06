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
}