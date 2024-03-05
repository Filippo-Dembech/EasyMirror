import 'dart:mirrors';

import '../PositionalParametersRequiredException.dart';

class MethodAnalyzer {
  // TODO: make 'method' private
  final MethodMirror method;
  late String _parametersString;

  MethodAnalyzer(this.method) {
    if (method.isConstructor) throw Exception("method can't be constructor");

    // ! compute here parametersString because it is used in other methods and computing
    // ! it every single time slows execution down
    int methodNameIndex = source.indexOf(name + "(");
    int methodParametersStart = methodNameIndex + name.length;
    int methodParametersEnd = 0;
    int openParenthesesAmount = 0;
    int closedParenthesesAmount = 0;
    for (int i = methodParametersStart; i < source.length; i++) {
      if (source.at(i).isEqualTo("(")) openParenthesesAmount++;
      if (source.at(i).isEqualTo(")")) closedParenthesesAmount++;
      if (openParenthesesAmount == closedParenthesesAmount) {
        methodParametersEnd = i + 1;
        break;
      }
    }

    // ! withoutWhiteSpaces() because it makes it easier to use string patterns throughout
    // ! the entire codebase without the worry to consider them.
    _parametersString = source
        .substring(methodParametersStart, methodParametersEnd)
        .withoutWhiteSpaces();
  }

  String get name => MirrorSystem.getName(method.simpleName);
  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => method.parameters;

  bool hasParameters() => method.parameters.isNotEmpty;
  bool hasNamedParameters() => method.parameters.any((parameter) => parameter.isNamed);
  bool hasPositionalParameters() => method.parameters.any((parameter) => !parameter.isNamed);

  String get parametersString => _parametersString;

  List<String> get parametersList => [
        ...positionalParameters,
        ...optionalPositionalParameters,
        ...namedParameters
      ].withoutEmptyStrings();

  List<String> get positionalParameters => _positionalParameters();
  List<String> get namedParameters => _namedParameters();
  List<String> get optionalPositionalParameters => _optionalPositionalParameters();


  List<String> _positionalParameters() {
    String optionalPositionalParameters = _optionalPositionalParameters().join(",");
    String namedParameters = _namedParameters().join(",");
    String positionalParameters = parametersString
        .replaceAll("[$optionalPositionalParameters]", "")
        .replaceAll("{$namedParameters}", "");
    return _splitParameters(positionalParameters.substring(1, positionalParameters.length - 1)).withoutEmptyStrings();
  }
  List<String> _optionalPositionalParameters() => _getEnclosedParameters("[", "]");
  List<String> _namedParameters() => _getEnclosedParameters("{", "}");


  List<String> _getEnclosedParameters(
      String openingDelimiter, String closingDelimiter) {
    int openingDelimitersAmount = 0;
    int closingDelimitersAmount = 0;
    int splitStart = 0;
    for (int i = 0; i < parametersString.length; i++) {

      if (parametersString.at(i).isEqualTo(openingDelimiter)) openingDelimitersAmount++;
      if (parametersString.at(i).isEqualTo(closingDelimiter)) closingDelimitersAmount++;

      // if it is the first opening delimiter met, save the starting index
      if (parametersString.at(i).isEqualTo(openingDelimiter) && splitStart.isEqualTo(0))
        splitStart = i + 1;

      if (openingDelimitersAmount.isEqualTo(closingDelimitersAmount) && openingDelimitersAmount > 0)
        return _splitParameters(parametersString.substring(splitStart, i)).withoutEmptyStrings();
    }

    return [];
  }


// ! parameters list must be without opening "(" and closing ")"
  List<String> _splitParameters(String text) {
    List<String> result = [];

    int openingParenthesis = 0;
    int closingParenthesis = 0;

    int openingAngleBrackets = 0;
    int closingAngleBrackets = 0;

    int splitStart = 0;

    for (int i = 0; i < text.length; i++) {
      if (text.at(i).isEqualTo("(")) openingParenthesis++;
      if (text.at(i).isEqualTo(")")) closingParenthesis++;

      if (text.at(i).isEqualTo("<")) openingAngleBrackets++;
      if (text.at(i).isEqualTo(">")) closingAngleBrackets++;

      if (text.at(i).isEqualTo(",") &&
          openingAngleBrackets.isEqualTo(closingAngleBrackets) &&
          openingParenthesis.isEqualTo(closingParenthesis)) {
        String substring = text.substring(splitStart, i);
        result.add(substring);
        splitStart = i + 1;
      }
    }

    // ? add the last trailing parameter
    result.add(text.substring(splitStart));

    return result;
  }
}


// helping extension methods
extension on String {
  String at(int i) => this[i];
  String withoutWhiteSpaces() => this.replaceAll(" ", "");
}

extension on Object {
  bool isEqualTo(Object o) => this == o && this.runtimeType == o.runtimeType;
}

extension on List<String> {
  List<String> withoutEmptyStrings() => this.where((str) => str != "").toList();
}