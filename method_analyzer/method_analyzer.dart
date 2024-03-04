import 'dart:mirrors';

import '../PositionalParametersRequiredException.dart';

class MethodAnalyzer {

  // TODO: make 'method' private
  final MethodMirror method;

  MethodAnalyzer(this.method) {
    if (method.isConstructor) throw Exception("method can't be constructor");
  }

  String get name => MirrorSystem.getName(method.simpleName);
  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => method.parameters;

  String get parametersString {
    int methodNameIndex = source.indexOf(name + "(");
    int methodParametersStart = methodNameIndex + name.length;
    int methodParametersEnd = 0;
    int openParenthesesAmount = 0;
    int closedParenthesesAmount = 0;
    for (int i = methodParametersStart; i < source.length; i++) {
      if (source[i].isEqualTo("(")) openParenthesesAmount++;
      if (source[i].isEqualTo(")")) closedParenthesesAmount++;
      if (openParenthesesAmount == closedParenthesesAmount) {
        methodParametersEnd = i + 1;
        break;
      }
    }
    return source.substring(methodParametersStart, methodParametersEnd).withoutWhiteSpaces();
  }

  List<String> get parametersList => [
    ...positionalParameters,
    ...optionalPositionalParameters,
    ...namedParameters
  ].where((parameter) => parameter != "").toList();

  bool hasParameters() => method.parameters.isNotEmpty;
  bool hasNamedParameters() => method.parameters.any((parameter) => parameter.isNamed);
  bool hasPositionalParameters() => method.parameters.any((parameter) => !parameter.isNamed);

  List<String> get positionalParameters => _positionalParameters(parametersString);
  List<String> get namedParameters => _namedParameters(parametersString);
  List<String> get optionalPositionalParameters => _optionalPositionalParameters(parametersString);


  String _delimitedParameters(String text, String openingDelimiter, String closingDelimiter) {
    int openingDelimiters = 0;
    int closingDelimiters = 0;
    int splitStart = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == openingDelimiter) openingDelimiters++;
      if (text[i] == closingDelimiter) closingDelimiters++;

      // if is the first delimiter save the starting index
      if (text[i] == openingDelimiter && splitStart == 0) splitStart = i + 1;

      if (openingDelimiters == closingDelimiters && openingDelimiters > 0) {
        return text.substring(splitStart, i);
      }
    }
    return "";
  }

  List<String> _positionalParameters(String text) {
    // 'op' stands for 'optional parameters'
    String op = _optionalPositionalParameters(text).join(",");
    // 'np' stands for 'named parameters'
    String np = _namedParameters(text).join(",");
    String positionalParameters = text.replaceAll("[$op]", "").replaceAll("{$np}", "");
    return _splitParameters(positionalParameters.substring(1, positionalParameters.length - 1)).where((parameter) => parameter != "").toList();
  }

  List<String> _optionalPositionalParameters(String text) {
    String delimitedParameters = _delimitedParameters(text, "[", "]");
    List<String> splitParameters = _splitParameters(delimitedParameters).where((parameter) => parameter != "").toList();
    return splitParameters;
  }


  List<String> _namedParameters(String text) => _splitParameters(_delimitedParameters(text, "{", "}")).where((parameter) => parameter != "").toList();


// ! parameters list must be without opening "(" and closing ")"
  List<String> _splitParameters(String text) {
    List<String> result = [];

    int openingParenthesis = 0;
    int closingParenthesis = 0;

    int openingGenerics = 0;
    int closingGenerics = 0;

    int splitStart = 0;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == "(") openingParenthesis++;
      if (text[i] == ")") closingParenthesis++;

      if (text[i] == "<") openingGenerics++;
      if (text[i] == ">") closingGenerics++;

      if (text[i] == "," && openingGenerics == closingGenerics && openingParenthesis == closingParenthesis) {
        String substring = text.substring(splitStart, i);
        result.add(substring);
        splitStart = i + 1;
      }
    }
    result.add(text.substring(splitStart));

    return result;
  }
}



extension on String {
  bool isEqualTo(String str) => this == str;
  String withoutWhiteSpaces() => this.replaceAll(" ", "");
}











