import '../string_extractor/delimiters.dart';

/// A String iterator that skips the characters within the specified delimiters.
///
/// ## Iterate Over Entire String
/// To iterate over the entire string just pass an empty set
/// to the [_delimitersSet] constructor argument or to the
/// [JumpingIterator.jump] method, which acts as a setter for
/// the delimiters set.
///
/// ---
/// ## Vocabulary
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
  int _currentIndex = -1;

  /// Creates a jumping iterator that iterates over the passed [_string]. The characters contained within the passed delimiters are skipped by the iterator. [_delimitersSet] define the set of delimiters the characters are contained in.
  JumpingIterator(this._string, this._delimitersSet);

  String get next {
    _currentIndex++;
    return _string[_currentIndex];
  }

  bool get hasNext {
    _jumpDelimitedAreas();
    return _hasNextChar();
  }

  /// Moves the iterator up to the ending of a delimited area or a
  /// set of delimited areas.
  void _jumpDelimitedAreas() {
    while (_inDelimitedArea()) {
      _jumpDelimitedArea();
    }
  }

  /// Checks whether the iterator points to a delimited area.
  ///
  /// A delimited area is defined by all the characters that live
  /// within an opening delimiter and its corresponding closing
  /// delimiter. The delimiters are included as part of the
  /// delimited area.
  bool _inDelimitedArea() =>
      _hasNextChar() &&
      _isNextCharOpeningDelimiter() &&
      _isThereClosingDelimiter();

  /// Checks whether the iterator still points to an element
  /// of the parsed string or has exceeded it.
  bool _hasNextChar() => _currentIndex + 1 < _string.length;

  /// Checks whether the current character is one of the opening
  /// delimiters present in [_delimitersSet].
  bool _isNextCharOpeningDelimiter() =>
      _delimitersSet.any(_openingDelimiterMatch);

  /// Checks whether the current character is an opening delimiter.
  bool _openingDelimiterMatch(Delimiters delimiters) =>
      _followingChar == delimiters.opening;

  /// Checks whether the current opening delimiter has also a
  /// matching closing delimiter.
  bool _isThereClosingDelimiter() {
    // ! this check prevents RangeError
    if (_currentIndex + 2 > _string.length) return false;

    String openingDelimiter = _followingChar;
    String closingDelimiter = _closingDelimiterOf(_followingChar);

    int openingDelimitersAmount = 1;
    int closingDelimitersAmount = 0;

    for (int i = _currentIndex + 2; i < _string.length; i++) {
      if (_string[i] == openingDelimiter) openingDelimitersAmount++;
      if (_string[i] == closingDelimiter) closingDelimitersAmount++;
      if (openingDelimitersAmount == closingDelimitersAmount) return true;
    }
    return false;
  }

  /// Moves the iterator at the end of the current delimited area.
  void _jumpDelimitedArea() {
    String openingDelimiter = _followingChar;
    String closingDelimiter = _closingDelimiterOf(_followingChar);

    int openingDelimitersAmount = 1;
    int closingDelimitersAmount = 0;

    while (openingDelimitersAmount != closingDelimitersAmount) {
      if (_string[_currentIndex + 2] == openingDelimiter) openingDelimitersAmount++;
      if (_string[_currentIndex + 2] == closingDelimiter) closingDelimitersAmount++;
      _currentIndex++;
    }
    _currentIndex++;
  }

  /// Returns the matching closing delimiter of the passed
  /// [openingDelimiter], if any.
  String _closingDelimiterOf(String openingDelimiter) {
    return _delimitersSet
        .firstWhere((delimiters) => _followingChar == delimiters.opening)
        .closing;
  }

  /// Returns the current character the iterator is pointing at.
  String get _followingChar => _charAt(_currentIndex + 1);

  /// Returns the character at the specified index [i] of the parsed [_string].
  String _charAt(int i) => _string[i];

  /// Reset the iterator position at the beginning of the parsed
  /// [_string].
  void revertIteration() {
    _currentIndex = -1;
  }

  /// Gives the iterator a new [string] to parse.
  void iterateOver(String string) {
    _string = string;
    revertIteration();
  }

  /// Specifies the new delimiters set.
  void jump(Set<Delimiters> newDelimitersSet) {
    _delimitersSet = newDelimitersSet;
  }

  /// Returns the index the iterator points at.
  int get currentIndex => _currentIndex;

  /// Loops throught all the characters and execute the passed
  /// function upon each of them.
  void forEach(void Function(String) f) {
    while (hasNext) {
      f(next);
    }
  }
}
