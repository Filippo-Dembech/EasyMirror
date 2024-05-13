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
  /// ```dart
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
  /// ```dart
  /// Delimiters.isOpeningDelimiter(")") // true
  /// Delimiters.isOpeningDelimiter("]") // true
  /// Delimiters.isOpeningDelimiter("(") // false
  /// Delimiters.isOpeningDelimiter("b") // false
  /// ```
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
  /// ```dart
  /// Delimiters.of("(") // returns 'Delimiters.ROUND_BRACKETS'
  /// Delimiters.of("[") // returns 'Delimiters.SQUARED_BRACKETS'
  /// Delimiters.of("()") // returns 'null'
  /// Delimiters.of("a") // returns 'null'
  /// ```
  static Delimiters? of(String string) => Delimiters.values
      .firstWhereOrNull((delimiters) => delimiters.contains(string));

  /// Returns a list of record pairs of the starting
  /// index and the closing index of the [delimiters]
  /// in the given [string].
  ///
  /// A string could contain more than one pair of
  /// delimiters or just delimiters (opening or closing)
  /// without their matching opening or closing delimiter.
  /// To understand how many 'complete' delimiter pair are
  /// present within a string this method returns a list
  /// of indexes that represent the starting and the closing
  /// indexes of a specified delimiters pair. Only 'complete'
  /// /'matching' delimiters are considered.
  ///
  /// For Example (in the example the parameter 'delimiters'
  /// is supposed to be Delimiters.ROUND_BRACKETS):
  /// ```dart
  /// allMatchesIndex.(..., "") // returns []
  /// allMatchesIndex.(..., "()()") // returns [(0,1), (2,3)]
  /// allMatchesIndex.(..., "(())") // returns [(0,3), (1,2)]
  /// allMatchesIndex.(..., "a") // returns []
  /// allMatchesIndex.(..., "(a)") // returns [(0,2)]
  /// allMatchesIndex.(..., "(a)(b)") // returns [(0,2), (3,5)]
  /// allMatchesIndex.(..., "((a))") // returns [(0,4), (1,3)]
  /// allMatchesIndex.(..., "((a)(b))") // returns [(0,7), (1,3), (4,6)]
  /// allMatchesIndex.(..., "(") // returns []
  /// allMatchesIndex.(..., "(a") // returns []
  /// allMatchesIndex.(..., "(()") // returns [(1,2)]
  /// allMatchesIndex.(..., "()))") // returns [(0,1)]
  /// allMatchesIndex.(..., "((a)") // returns [(1,3)]
  /// allMatchesIndex.(..., "(a)))") // returns [(0,2)]
  /// ```
  static List<MatchIndexes> allMatchesIndexes(
    Delimiters delimiters,
    String string,
  ) {
    return AllMatchesIndexes
              .of(delimiters)
              .findsFor(string);
  }

  /// Executes the given function over the current delimiters
  /// giving the ability to count the number of occurrences
  /// of the opening or closing delimiters.
  ///
  /// This method could be used to have total control
  /// over how matching delimiters are calculated.
  /// By using the 'openingCount' and 'closingCount'
  /// parameters with some conditional logic you can
  /// decide what defines delimiters to match and what
  /// doesn't.
  ///
  /// For example, check whether in a string there are
  /// matching delimiters or not:
  /// ```dart
  ///
  /// String string = "(hi there) from delimiters"
  /// bool result = false
  ///
  /// Delimiters.ROUND_BRACKETS.countOperation((
  ///     delimiters,
  ///     openingCount,
  ///     closingCount,
  ///  ) {
  ///     for (int i = 0; i < string.length; i++) {
  ///       if (string[i] == delimiters.opening) openingCount++;
  ///       if (string[i] == delimiters.closing) closingCount++;
  ///       if (openingCount == closingCount) result = true;
  ///     }
  ///  });
  /// ```
  void countOperation(
      Function(
        Delimiters delimiters,
        int openingCount,
        int closingCount,
      ) f) {
    int openingCount = 0;
    int closingCount = 0;
    f(this, openingCount, closingCount);
  }

  /// Checks whether the passed [string] is one of
  /// these [Delimiters].
  ///
  /// For Example:
  /// ```dart
  /// Delimiters.ROUND_BRACKETS.contains("(") // true
  /// Delimiters.ROUND_BRACKETS.contains(")") // true
  /// Delimiters.ROUND_BRACKETS.contains("(()") // false
  /// Delimiters.ROUND_BRACKETS.contains("[") // false
  /// Delimiters.ROUND_BRACKETS.contains("a") // false
  /// ```
  bool contains(String string) => opening == string || closing == string;

  /// Converts these [Delimiters] into a [String]
  String toString() => "'$opening', '$closing'";
}

/// A record defining [Delimiters] matching indexes
/// `(opening_delimiter_index, closing_delimiter_index)`;
typedef MatchIndexes = (int, int); // TODO: rename IndexesMatch

/// An object method that stores the algorithm to find
/// all the [MatchIndexes] of a [Delimiters] pair within
/// a string.
class AllMatchesIndexes {
  /// A list to store all the [MatchIndexes] that
  /// will be return as result of the computation.
  List<MatchIndexes> _result = [];

  /// The [Delimiters] the algorithm has to find the
  /// matching indexes of.
  Delimiters _delimiters;

  /// Creates an instance of the [AllMatchesIndexes]
  /// algorithm upon the passed [Delimiters].
  AllMatchesIndexes.of(this._delimiters);

  /// computes the list of [MatchIndexes] depending
  /// on the passed parameters of the algorithm.
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
