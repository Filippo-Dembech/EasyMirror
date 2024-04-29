import 'dart:mirrors';

import 'ConstructorException.dart';
import 'Extensions/list__empty_string_remover.dart';
import 'Extensions/object__equal_objects.dart';
import 'Extensions/string__element_fetcher.dart';
import 'Extensions/string_whitespaces_remover.dart';
import 'String Extractor/delimiters.dart';
import 'String Extractor/string_extractor.dart';
import 'parameter.dart';
import 'parameter_type.dart';
import 'temp/parameters_reporter.dart';

class MethodAnalyzer {
  // TODO: make 'method' private
  MethodMirror method;
  late String _parametersDeclarationWithoutSpaces;
  List<ParameterMirror> _parametersMirrors;

  MethodAnalyzer(this.method) : _parametersMirrors = method.parameters {
    if (method.isConstructor) throw ConstructorException();

    // ! '_parametersDeclarationWithoutSpaces' is computed here because it is
    // ! used in other methods and computing it every single
    // ! time slows execution down
    // ! withoutWhiteSpaces() because it makes it easier to use string patterns throughout
    // ! the entire codebase without the worry to consider them.
    _parametersDeclarationWithoutSpaces =
        _extractParametersDeclarationFrom(source);
    print("source: $source"); // * DEBUG
  }

  String _extractParametersDeclarationFrom(String source) {
    int methodNameIndex = source.indexOf(methodName + "(");
    String leftTrimSource =
        source.substring(methodNameIndex + methodName.length);
    return StringExtractor.parsing(leftTrimSource)
        .extract()
        .withoutWhiteSpaces();
  }

  String get methodName => MirrorSystem.getName(method.simpleName);

  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => _parametersMirrors;

  String get parametersReport => ParametersReporter().reports(this.parameters);

  bool get hasParameters => method.parameters.isNotEmpty;

  bool get hasNamedParameters =>
      method.parameters.any((parameter) => parameter.isNamed);

  bool get hasPositionalParameters =>
      method.parameters.any((parameter) => !parameter.isNamed);

  // =============== EXTRACT CLASS ===============
  // parametersNames calculation could be put within an utility class
  List<String> get parametersNames =>
      parametersMirrors.map(_parameterMirrorToParameterName).toList();

  String _parameterMirrorToParameterName(ParameterMirror parameter) =>
      MirrorSystem.getName(parameter.simpleName);

  // =============================================

  List<String> get _parametersTexts => [
        ..._positionalParameters(),
        ..._optionalPositionalParameters(),
        ..._namedParameters(),
      ].withoutEmptyStrings();

  List<String> _positionalParameters() {
    if (_thereAreNoParameters() ||
        _thereAreOnlyOptionalPositionalParameters() ||
        _thereAreOnlyNamedParameters()) return [];

    int endingIndex = _findPositionalParametersEndingIndexInParametersDeclarationWithoutSpaces();

    String parameters =
        _parametersDeclarationWithoutSpaces.substring(0, endingIndex);
    List<String> splitParameters = _splitParameters(parameters);
    List<String> splitParametersWithoutEmptyString =
        splitParameters.withoutEmptyStrings();
    List<String> positionalParameters = splitParametersWithoutEmptyString
        .map((parameter) => "Positional::$parameter")
        .toList();

    return positionalParameters;
  }

  bool _thereAreNoParameters() => _parametersDeclarationWithoutSpaces == "()";
  bool _thereAreOnlyOptionalPositionalParameters() => _optionalPositionalParameters().length == parametersNames.length;
  bool _thereAreOnlyNamedParameters() => _namedParameters().length == parametersNames.length;

  int _findPositionalParametersEndingIndexInParametersDeclarationWithoutSpaces() {
    int endingIndex = _parametersDeclarationWithoutSpaces.length;
    for (int i = 0; i < endingIndex - 1; i++) {
      if (_optionalPositionalParametersStartAt(i) ||
          _namedParametersStartAt(i)) {
        endingIndex = i;
      }
    }
    return endingIndex;
  }

  bool _optionalPositionalParametersStartAt(int i) => _parametersDeclarationWithoutSpaces.at(i) == "," && _parametersDeclarationWithoutSpaces.at(i + 1) == "[";
  bool _namedParametersStartAt(int i) => _parametersDeclarationWithoutSpaces.at(i) == "," && _parametersDeclarationWithoutSpaces.at(i + 1) == "{";

  List<String> _optionalPositionalParameters() =>
      _getParametersEnclosedIn(Delimiters.SQUARED_BRACKETS)
          .map((parameter) => "OptionalPositional::$parameter")
          .toList();

  List<String> _namedParameters() =>
      _getParametersEnclosedIn(Delimiters.CURLY_BRACKETS)
          .map((parameter) => "Named::$parameter")
          .toList();

  List<String> _getParametersEnclosedIn(Delimiters delimiters) {
    String parameters =
        StringExtractor.parsing(_parametersDeclarationWithoutSpaces)
            .within(delimiters)
            .extract();
    return _splitParameters(parameters).withoutEmptyStrings();
  }

  // TODO: replace _splitParameters() method with StringSplitter
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

  List<String> get parametersDefaults => _parametersDefaults();

  List<String> _parametersDefaults() {
    List<String> result = [];

    for (String parameter in _parametersTexts) {
      int equalSignIndex = parameter.indexOf("=");
      String defaultDeclaration = "";
      if (_thereIsEqualSignIn(parameter))
        defaultDeclaration = " = ${parameter.substring(equalSignIndex + 1)}";
      result.add(defaultDeclaration);
    }

    return result;
  }

  List<Parameter> get parameters {
    List<Parameter> result = [];
    for (String parameter in parametersDeclarations) {
      String parameterType = parameter.split("::")[0];
      String parameterDeclaration = parameter.split("::")[1];
      String parameterDataType = parameterDeclaration.split(" ")[0];
      String parameterName = parameterDeclaration.split(" ")[1];
      String? defaultValue;
      int equalSignIndex = parameter.indexOf("=");
      if (_thereIsEqualSignIn(parameter))
        defaultValue = " ${parameter.substring(equalSignIndex)}";
      bool isRequired = false;
      bool hasDefaultValue = false;
      bool isNamed = false;
      bool isOptionalPositional = false;
      bool isPositional = false;
      bool isNullable = false;
      ParameterType type = ParameterType.positional;

      // isRequired
      if (parameterDataType == "required") {
        isRequired = true;
        parameterDataType = parameterDeclaration.split(" ")[1];
        parameterName = parameterDeclaration.split(" ")[2];
      }

      if (parameterType == "Positional") isRequired = true;

      if (_thereIsEqualSignIn(parameter)) hasDefaultValue = true;
      if (parameter.startsWith("Named")) {
        isNamed = true;
        type = ParameterType.named;
      }
      if (parameter.startsWith("OptionalPositional")) {
        isOptionalPositional = true;
        isPositional = true;
        type = ParameterType.optionalPositional;
      }
      if (parameter.startsWith("Positional")) {
        isPositional = true;
        type = ParameterType.positional;
      }
      if (parameterDataType.endsWith("?")) isNullable = true;

      result.add(
        Parameter(
          dataType: parameterDataType,
          name: parameterName,
          type: type,
          defaultValue: defaultValue,
          isRequired: isRequired,
          hasDefaultValue: hasDefaultValue,
          isNamed: isNamed,
          isOptionalPositional: isOptionalPositional,
          isPositional: isPositional,
          isNullable: isNullable,
        ),
      );
    }
    return result;
  }

  bool _thereIsEqualSignIn(String parameter) => parameter.contains("=");

  List<String> get parametersDeclarations => _parametersDeclarations();

  List<String> _parametersDeclarations() {
    List<String> result = [];
    for (int i = 0; i < _parametersTexts.length; i++) {
      result.add(
          "${_parametersTexts[i].split("::")[0]}::${_parametersDataTypes()[i]} ${parametersNames[i]}${parametersDefaults[i]}");
    }
    return result;
  }

  List<String> _parametersDataTypes() {
    List<String> result = [];
    for (int i = 0; i < _parametersTexts.length; i++) {
      String parameterText = _parametersTexts[i];
      String parameterName = parametersNames[i];
      String parameterPrecedingName = parameterText
          .substring(0, parameterText.length - parameterName.length)
          .split("::")[1];
      int indexOfEqual = parameterText.indexOf("=");

      if (_thereIsEqualSignIn(parameterText))
        parameterPrecedingName =
            parameterText.substring(0, indexOfEqual - 1).split("::")[1];

      String parameterDataType = parameterPrecedingName;
      if (parameterPrecedingName.startsWith("required"))
        parameterDataType = "required ${parameterPrecedingName.substring(8)}";

      result.add(parameterDataType);
    }
    return result;
  }
}