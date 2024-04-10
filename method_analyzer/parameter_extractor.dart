import 'Extensions/object__equal_objects.dart';
import 'Extensions/string__element_fetcher.dart';
import 'Extensions/string_whitespaces_remover.dart';

class ParametersExtractor {
  String _source;
  String _methodName = "";
  int _parametersStartingIndex = 0;
  int _parametersEndingIndex = 0;
  int _openingParenthesesAmount = 0;
  int _closingParenthesesAmount = 0;

  ParametersExtractor.of(this._source);

  // ! withoutWhiteSpaces() because it makes it easier to use string patterns throughout
  // ! the entire codebase without the worry to consider them.
  String findsParametersOf(String methodName) {
    _methodName = methodName;

    _parametersStartingIndex = _getParametersStartingIndexIn(_source);

    for (int i = _parametersStartingIndex; i < _source.length; i++) {
      if (_source.at(i).isEqualTo("(")) _openingParenthesesAmount++;
      if (_source.at(i).isEqualTo(")")) _closingParenthesesAmount++;
      if (_openingParenthesesAmount == _closingParenthesesAmount) {
        _parametersEndingIndex = i + 1;
        break;
      }
    }

    return _source
        .substring(_parametersStartingIndex, _parametersEndingIndex)
        .withoutWhiteSpaces();
  }

  int _getParametersStartingIndexIn(String source) {
    int methodNameIndex = source.indexOf(_methodName + "(");
    return methodNameIndex + _methodName.length;
  }

  String get parameters => _source
      .substring(_parametersStartingIndex, _parametersEndingIndex)
      .withoutWhiteSpaces();

}