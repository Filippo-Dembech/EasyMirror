class ParametersExtractor {
  String _source;
  String _methodName;
  int _parametersStartingIndex = 0;
  int _parametersEndingIndex = 0;
  int _openingParenthesesAmount = 0;
  int _closingParenthesesAmount = 0;

  ParametersExtractor(this._source, this._methodName) {
    _parametersStartingIndex = _getParametersStartingIndexIn(_source);

    for (int i = _parametersStartingIndex; i < _source.length; i++) {
      if (_source.at(i).isEqualTo("(")) _openingParenthesesAmount++;
      if (_source.at(i).isEqualTo(")")) _closingParenthesesAmount++;
      if (_openingParenthesesAmount == _closingParenthesesAmount) {
        _parametersEndingIndex = i + 1;
        break;
      }
    }
  }

  int _getParametersStartingIndexIn(String source) {
    int methodNameIndex = source.indexOf(_methodName + "(");
    return methodNameIndex + _methodName.length;
  }

  // ! withoutWhiteSpaces() because it makes it easier to use string patterns throughout
  // ! the entire codebase without the worry to consider them.
  String get parameters => _source
      .substring(_parametersStartingIndex, _parametersEndingIndex)
      .withoutWhiteSpaces();
}


// helping extension methods
extension on String {
  String at(int i) => this[i];

  String withoutWhiteSpaces() => this.replaceAll(" ", "");
}

extension on Object {
  bool isEqualTo(Object o) => this == o && this.runtimeType == o.runtimeType;
}
