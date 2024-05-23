import 'package:test/expect.dart';
import 'package:test/test.dart';

import 'white_spaces_permutator.dart';

void main() {
  test("\"\"", () {
    expect(WhiteSpacesPermutator.permutationsOf(""), equals([]));
  });
  test("a", () {
    expect(WhiteSpacesPermutator.permutationsOf("a"), equals(["a"]));
  });
  test("a b", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a b"),
        unorderedEquals([
          "a b",
          "ab",
        ]));
  });
  test("a b c", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a b c"),
        unorderedEquals([
          "a b c",
          "a bc",
          "ab c",
          "abc",
        ]));
  });
  test("a b c d", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a b c d"),
        unorderedEquals([
          "a b c d",
          "a bc d",
          "ab c d",
          "abc d",
          "a b cd",
          "a bcd",
          "ab cd",
          "abcd"
        ]));
  });
  test("a   b", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a   b"),
        unorderedEquals([
          "a b",
          "ab",
        ]));
  });
  test("a   b   c", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a   b   c"),
        unorderedEquals([
          "a b c",
          "a bc",
          "ab c",
          "abc",
        ]));
  });
  test("a   b   c   d", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a   b   c   d"),
        unorderedEquals([
          "a b c d",
          "a bc d",
          "ab c d",
          "abc d",
          "a b cd",
          "a bcd",
          "ab cd",
          "abcd"
        ]));
  });
  test("   a   b   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   a   b   "),
        unorderedEquals([
          "a b",
          "ab",
        ]));
  });
  test("   a   b   c   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   a   b   c   "),
        unorderedEquals([
          "a b c",
          "a bc",
          "ab c",
          "abc",
        ]));
  });
  test("   a   b   c   d   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   a   b   c   d   "),
        unorderedEquals([
          "a b c d",
          "a bc d",
          "ab c d",
          "abc d",
          "a b cd",
          "a bcd",
          "ab cd",
          "abcd"
        ]));
  });

  test("hi there", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi there"),
        unorderedEquals([
          "hi there",
          "hithere",
        ]));
  });
  test("hi there mate", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi there mate"),
        unorderedEquals([
          "hi there mate",
          "hi theremate",
          "hithere mate",
          "hitheremate",
        ]));
  });
  test("hi there mate sup?", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi there mate sup?"),
        unorderedEquals([
          "hi there mate sup?",
          "hi theremate sup?",
          "hithere mate sup?",
          "hitheremate sup?",
          "hi there matesup?",
          "hi therematesup?",
          "hithere matesup?",
          "hitherematesup?",
        ]));
  });
  test("hi   there", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi   there"),
        unorderedEquals([
          "hi there",
          "hithere",
        ]));
  });
  test("hi   there   mate", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi   there   mate"),
        unorderedEquals([
          "hi there mate",
          "hi theremate",
          "hithere mate",
          "hitheremate",
        ]));
  });
  test("hi   there   mate   sup?", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("hi   there   mate   sup?"),
        unorderedEquals([
          "hi there mate sup?",
          "hi theremate sup?",
          "hithere mate sup?",
          "hitheremate sup?",
          "hi there matesup?",
          "hi therematesup?",
          "hithere matesup?",
          "hitherematesup?",
        ]));
  });
  test("   hi   there   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   hi   there   "),
        unorderedEquals([
          "hi there",
          "hithere",
        ]));
  });
  test("   hi   there   mate   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   hi   there   mate   "),
        unorderedEquals([
          "hi there mate",
          "hi theremate",
          "hithere mate",
          "hitheremate",
        ]));
  });
  test("   hi   there   mate   sup?   ", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("   hi   there   mate   sup?   "),
        unorderedEquals([
          "hi there mate sup?",
          "hi theremate sup?",
          "hithere mate sup?",
          "hitheremate sup?",
          "hi there matesup?",
          "hi therematesup?",
          "hithere matesup?",
          "hitherematesup?",
        ]));
  });

  test("a b c d e", () {
    expect(
        WhiteSpacesPermutator.permutationsOf("a b c d e"),
        unorderedEquals([
          "a b c d e",
          "a bc d e",
          "ab c d e",
          "abc d e",
          "a b cd e",
          "a bcd e",
          "ab cd e",
          "abcd e",
          "a b c de",
          "a bc de",
          "ab c de",
          "abc de",
          "a b cde",
          "a bcde",
          "ab cde",
          "abcde"
        ]));
  });
}
