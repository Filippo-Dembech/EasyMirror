import '../string_extractor/delimiters.dart';

/// A String iterator that skips the characters within the specified delimiters.
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

  /// The current index representing the position of the iterator
  /// within the [_string].
  int _currentIndex = -1;

  /// Creates a jumping iterator instance that iterates over
  /// the passed [string]. The characters contained within the
  /// passed delimiters are skipped by the iterator. [delimitersSet]
  /// define the set of delimiters the characters are contained in.
  JumpingIterator(
    String string, {
    required Set<Delimiters> delimitersSet,
  })  : _string = string,
        _delimitersSet = delimitersSet;

  /// Gets the next character of the iteration.
  String get next {
    _currentIndex++;
    return _string[_currentIndex];
  }

  /// Whether the iterator has another not contained character to
  /// iterate over.
  bool get hasNext {
    _jumpDelimitedAreas();
    return _hasNextChar();
  }

  /// Moves the iterator up to the end of a delimited area or a
  /// set of contiguous delimited areas.
  void _jumpDelimitedAreas() {
    while (_inDelimitedArea()) {
      _jumpDelimitedArea();
    }
  }

  /// Whether the iterator points to a delimited area.
  bool _inDelimitedArea() =>
      _hasNextChar() &&
      _isNextCharOpeningDelimiter() &&
      _isThereClosingDelimiter();

  /// Whether the iterator has got another character
  /// to iterate over.
  bool _hasNextChar() => _currentIndex + 1 < _string.length;

  /// Whether the following character is one of the
  /// opening delimiters present in [_delimitersSet].
  bool _isNextCharOpeningDelimiter() =>
      _delimitersSet.any(_openingDelimiterMatch);

  /// Whether the following character is an opening
  /// delimiter.
  bool _openingDelimiterMatch(Delimiters delimiters) =>
      _followingChar == delimiters.opening;

  /// Whether the current opening delimiter
  /// has also a matching closing delimiter.
  bool _isThereClosingDelimiter() {
    // * this check prevents RangeError
    if (_currentIndex + 2 > _string.length) return false;

    bool result = false;

    Delimiters.of(_followingChar)!.countOperation((
      delimiters,
      openingCount,
      closingCount,
    ) {
      for (int i = _currentIndex + 2; i < _string.length; i++) {
        if (_string[i] == delimiters.opening) openingCount++;
        if (_string[i] == delimiters.closing) closingCount++;
        if (openingCount == closingCount) result = true;
      }
    });

    return result;
  }

  /// Moves the iterator at the end of the current delimited area.
  void _jumpDelimitedArea() {
    Delimiters.of(_followingChar)!.countOperation((
      delimiters,
      openingCount,
      closingCount,
    ) {
      while (openingCount != closingCount) {
        if (_string[_currentIndex + 2] == delimiters.opening) openingCount++;
        if (_string[_currentIndex + 2] == delimiters.closing) closingCount++;
        _currentIndex++;
      }
      _currentIndex++;
    });
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

  /// Loops throught all the characters and execute the passed
  /// function upon each of them.
  void forEach(void Function(String, int) f) {
    while (hasNext) {
      f(next, _currentIndex);
    }
  }
}
