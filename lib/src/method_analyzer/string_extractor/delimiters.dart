import 'package:collection/collection.dart';

enum Delimiters {
  ROUND_BRACKETS("(", ")"),
  SQUARED_BRACKETS("[", "]"),
  CURLY_BRACKETS("{", "}"),
  DIAMOND_BRACKETS("<", ">");

  /// The opening delimiter of the [Delimiters] pair.
  final String opening;

  /// The closing delimiter or the [Delimiters] pair.
  final String closing;

  /// Create an instance of [Delimiters] pair.
  const Delimiters(this.opening, this.closing);

  /// Checks whether the given [string] is an opening delimiter.
  /// 
  /// It checks the passed [string] against all the available
  /// [Delimiters] pairs, if any of them has got the passed
  /// [string] as opening delimiters, true is returned.
  /// 
  /// For Example:
  /// ```
  /// Delimiters.isOpeningDelimiter("(") // true
  /// Delimiters.isOpeningDelimiter("[") // true
  /// Delimiters.isOpeningDelimiter(")") // false
  /// Delimiters.isOpeningDelimiter("b") // false
  /// ```
  static bool isOpeningDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.opening == string);

  /// Checks whether the given [string] is a closing delimiter.
  /// 
  /// It checks the passed [string] against all the available
  /// [Delimiters] pairs, if any of them has got the passed
  /// [string] as closing delimiters, true is returned.
  /// 
  /// For Example:
  /// ```
  /// Delimiters.isOpeningDelimiter(")") // true
  /// Delimiters.isOpeningDelimiter("]") // true
  /// Delimiters.isOpeningDelimiter("(") // false
  /// Delimiters.isOpeningDelimiter("b") // false
  static bool isClosingDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.closing == string);

  /// Returns the [Delimiters] pair instance which has got
  /// the passed [string] as opening or closing delimiter.
  /// 
  /// It checks whether the given [string] matches any of
  /// the opening or closing delimiters of all the available
  /// [Delimiters] pairs, if a match is found then the
  /// [Delimiters] pair that contains the match is returned.
  /// 
  /// For Example:
  /// ```
  /// Delimiters.of("(") // returns 'Delimiters.ROUND_BRACKETS'
  /// Delimiters.of("[") // returns 'Delimiters.SQUARED_BRACKETS'
  /// Delimiters.of("()") // returns 'null'
  /// Delimiters.of("a") // returns 'null'
  /// ```
  static Delimiters? of(String string) =>
      Delimiters.values.firstWhereOrNull((delimiters) => delimiters.contains(string));

  // TODO: refactor
  static List<MatchIndexes> allMatchesIndexes(
    Delimiters delimiters,
    String string,
  ) {
    return AllMatchesIndexes.of(delimiters).findsFor(string);
  }

  static countOperation(
      Delimiters delimiters,
      Function(
        Delimiters delimiters,
        int openingCount,
        int closingCount,
      ) f) {
    int openingCount = 1;
    int closingCount = 0;
    f(delimiters, openingCount, closingCount);
  }

  bool contains(String string) => opening == string || closing == string;

  String toString() => "'$opening', '$closing'";
}

typedef MatchIndexes = (int, int);

class AllMatchesIndexes {
  List<MatchIndexes> _result = [];
  Delimiters _delimiters;
  int closingIndex = 0;

  AllMatchesIndexes.of(this._delimiters);

  // TODO: make it recursive
  List<MatchIndexes> findsFor(String string) {
    for (int i = 0; i < string.length; i++) {
      if (string[i] == _delimiters.opening) {
        int openingDelimitersCount = 0;
        int closingDelimitersCount = 0;
        for (int j = i; j < string.length; j++) {
          if (string[j] == _delimiters.opening) openingDelimitersCount++;
          if (string[j] == _delimiters.closing) closingDelimitersCount++;
          if (openingDelimitersCount == closingDelimitersCount) {
            _result.add((i, j));
            break;
          }
          ;
        }
      }
    }
    return _result;
  }
}

void main() {
  print("delimiters of --> ${Delimiters.of("A")}");
  print("delimiters of --> ${Delimiters.of("()")}");
}