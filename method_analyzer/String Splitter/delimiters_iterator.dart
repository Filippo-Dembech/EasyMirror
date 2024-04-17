import '../String Extractor/delimiters.dart';

class DelimitedIterator {
  String _string;
  List<Delimiters> _delimitersPairs;
  int _currentIndex = 0;

  DelimitedIterator(this._string, [this._delimitersPairs = const []]);

  String get next => _charAt(_currentIndex++);

  bool get hasNext {
    _skipDelimitedAreas();
    return _currentIndex < _string.length;
  }

  void _skipDelimitedAreas() {
    while (_withinStringRange() && _inDelimitedArea()) {
      _skipDelimitedArea();
    }
  }

  bool _withinStringRange() => _currentIndex < _string.length;

  bool _inDelimitedArea() {
    if (_charIsAnOpeningDelimiter() && _thereIsClosingDelimiter()) {
      return true;
    }
    return false;
  }

  bool _charIsAnOpeningDelimiter() =>
      _delimitersPairs.any(_openingDelimiterMatch);

  bool _openingDelimiterMatch(Delimiters delimiters) =>
      _currentChar == delimiters.opening;

  bool _thereIsClosingDelimiter() {
    String? closingDelimiter = _closingDelimiterOf(_currentChar);
    for (int i = _currentIndex; i < _string.length; i++) {
      if (_charAt(i) == closingDelimiter) return true;
    }
    return false;
  }

  void _skipDelimitedArea() {
    String? closingDelimiter = _closingDelimiterOf(_currentChar);
    while (_currentChar != closingDelimiter) _currentIndex++;
    _currentIndex++; // to skip also the closing delimiter
  }

  String? _closingDelimiterOf(String openingDelimiter) {
    for (var delimiters in _delimitersPairs) {
      if (openingDelimiter == delimiters.opening) {
        return delimiters.closing;
      }
    }
    return null;
  }

  String get _currentChar => _charAt(_currentIndex);

  String _charAt(int i) => _string[i];

  void revertIteration() {
    _currentIndex = 0;
  }

  void iterateOver(String string) {
    _string = string;
    revertIteration();
  }
}
