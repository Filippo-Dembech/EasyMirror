import 'dart:async';

enum Delimiters {
  ROUND_BRACKETS("(", ")"),
  SQUARED_BRACKETS("[", "]"),
  CURLY_BRACKETS("{", "}"),
  DIAMOND_BRACKETS("<", ">");

  final String opening;
  final String closing;

  const Delimiters(this.opening, this.closing);

  static bool isOpeningDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.opening == string);

  static bool isClosingDelimiter(String string) =>
      Delimiters.values.any((delimiters) => delimiters.closing == string);

  static Delimiters of(String string) =>
      Delimiters.values.firstWhere((delimiters) => delimiters.contains(string));

  // TODO: refactor
  static List<MatchIndexes> allMatchesIndexes(
    Delimiters delimiters,
    String string,
  ) {
    return AllMatchesIndexes.of(delimiters).findsFor(string);
    /*
    List<MatchIndexes> result = [];
    for (int i = 0; i < string.length; i++) {
      if (string[i] == delimiters.opening) {
        int openingDelimitersCount = 0;
        int closingDelimitersCount = 0;
        for (int j = i; j < string.length; j++) {
          if (string[j] == delimiters.opening) openingDelimitersCount++;
          if (string[j] == delimiters.closing) closingDelimitersCount++;
          if (openingDelimitersCount == closingDelimitersCount) {
            result.add((i, j));
            break;
          }
          ;
        }
      }
    }
    return result;
    */
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
  print(Delimiters.allMatchesIndexes(Delimiters.ROUND_BRACKETS, "(())"));
}
