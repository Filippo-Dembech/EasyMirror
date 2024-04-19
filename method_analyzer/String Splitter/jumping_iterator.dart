import '../String Extractor/delimiters.dart';

/// A String iterator that skips the characters within the specified delimiters.
///
/// ---
/// VOCABULARY:
/// - If a character lives between an opening delimiter and a closing delimiter it means that the character **is contained** within the delimiters or that the delimiters *contain* the character. For example:
/// ```dart
/// "sample (string)" // 'string' is contained within the delimiters '()'
/// "[sample] string" // 'sample' is contained within the delimiters '[]'
/// ```
/// - [Delimiters] are composed by an _opening_ and a _closing_ delimiter. For example: [Delimiters.ROUND_BRACKETS] represents the combination of opening and closing delimiters made up of round brackets - `()`.
/// - A **delimited area** is the area composed by the delimiters and the characters contained by them. For example:
/// ```dart
/// "sample (string)" // '(string)' is the delimited area defined by the delimiters '()'
/// "[sample] string" // '[sampe]' is the delimited area defined by the delimiters '[]'
/// ```
class JumpingIterator {
  /// The parsed string.
  String _string;

  /// The set of delimiters that define the delimiting areas.
  Set<Delimiters> _delimitersSet;

  /// The current index representing the position of the iterator within the [_string].
  int _currentIndex = 0;

  /// Creates a jumping iterator that iterates over the passed [_string]. The characters contained within the passed delimiters are skipped by the iterator. [_delimitersSet] define the set of delimiters the characters are contained in.
  JumpingIterator(this._string, this._delimitersSet);

  /// Returns the next character.
  String get next => _charAt(_currentIndex++);

  /// Checks whether this iterator has other characters to iterate over.
  bool get hasNext {
    _jumpDelimitedAreas();
    return _currentIndex < _string.length;
  }

  /// Moves the iterator up to the ending of a delimited area or a set of delimited areas.
  void _jumpDelimitedAreas() {
    while (_withinStringRange() && _inDelimitedArea()) {
      _jumpDelimitedArea();
    }
  }

  /// Checks whether the iterator still points to an element of the parsed string or has exceeded it.
  bool _withinStringRange() => _currentIndex < _string.length;

  /// Checks whether the iterator points to a delimited area.
  /// 
  /// A delimited area is defined by all the characters that live
  /// within an opening delimiter and its corresponding closing
  /// delimiter. The delimiters are included as part of the
  /// delimited area.
  bool _inDelimitedArea() =>
      _charIsAnOpeningDelimiter() && _thereIsClosingDelimiter();

  /// Checks whether the current character is one of the opening delimiters present in [_delimitersSet].
  bool _charIsAnOpeningDelimiter() =>
      _delimitersSet.any(_openingDelimiterMatch);

  /// Checks whether the current character is an opening delimiter.
  bool _openingDelimiterMatch(Delimiters delimiters) =>
      _currentChar == delimiters.opening;

  /// Checks whether the current opening delimiter has also a matching closing delimiter.
  bool _thereIsClosingDelimiter() {
    return _string
        .substring(_currentIndex)
        .contains(_closingDelimiterOf(_currentChar));
  }

  /// Moves the iterator at the end of the current delimited area.
  void _jumpDelimitedArea() {
    String closingDelimiter = _closingDelimiterOf(_currentChar);
    while (_currentChar != closingDelimiter) _currentIndex++;
    _currentIndex++; // to skip also the closing delimiter
  }

  /// Returns the matching closing delimiter of the passed [openingDelimiter], if any.
  String _closingDelimiterOf(String openingDelimiter) {
    return _delimitersSet
        .firstWhere((delimiters) => _currentChar == delimiters.opening)
        .closing;
    /*
    for (var delimiters in _delimitersSet) {
      if (openingDelimiter == delimiters.opening) {
        return delimiters.closing;
      }
    }
    */
  }

  /// Returns the current character the iterator is pointing at.
  String get _currentChar => _charAt(_currentIndex);

  /// Returns the character at the specified index [i] of the parsed [_string].
  String _charAt(int i) => _string[i];

  /// Reset the iterator position at the beginning of the parsed [_string].
  void revertIteration() {
    _currentIndex = 0;
  }

  /// Gives the iterator a new [string] to parse.
  JumpingIterator iterateOver(String string) {
    _string = string;
    revertIteration();
    return this;
  }

  /// Specifies the new delimiters set.
  JumpingIterator jump(Set<Delimiters> newDelimitersSet) {
    _delimitersSet = newDelimitersSet;
    return this;
  }

  /// Returns the index the iterator points at.
  ///
  /// __NOTE__: it doesn't point at the current fetched character.
  /// this could be a problem in the [SkippingIterator.forEach]
  /// because [currentIndex] isn't refferring to the index of the
  /// current character but it refers to the index of the _next_
  /// one.
  int get currentIndex => _currentIndex;

  /// Loops throught all the characters and execute the passed function upon each of them.
  void forEach(Function(String) f) {
    while (hasNext) {
      f(next);
    }
  }
}
