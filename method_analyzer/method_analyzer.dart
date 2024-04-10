import 'dart:mirrors';

import '../ConstructorException.dart';
import '../PositionalParametersRequiredException.dart';
import 'Extensions/list__empty_string_remover.dart';
import 'Extensions/object__equal_objects.dart';
import 'Extensions/string__element_fetcher.dart';
import 'parameter.dart';
import 'parameter_extractor.dart';
import 'parameter_type.dart';



class MethodAnalyzer {
  // TODO: make 'method' private
  final MethodMirror method;
  late String _parametersDeclaration;
  late List<ParameterMirror> _parametersMirrors;

  int getParametersStartingIndexIn(String source) {
    int methodNameIndex = source.indexOf(methodName + "(");
    return methodNameIndex + methodName.length;
  }

  MethodAnalyzer(this.method) :
        _parametersMirrors = method.parameters {
    if (method.isConstructor) throw ConstructorException();

    // ! '_parametersString' is computed here because it is
    // ! used in other methods and computing it every single
    // ! time slows execution down
    final parametersExtractor = ParametersExtractor.of(source);
    _parametersDeclaration = parametersExtractor.findsParametersOf(methodName);
  }

  String get methodName => MirrorSystem.getName(method.simpleName);

  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => _parametersMirrors;
  String get parametersDeclaration => _parametersDeclaration;

  String get parametersReport => ""
      "parameters: $parameters\n"
      "names: ${[ for (Parameter parameter in parameters) parameter.name ]}\n"
      "dataTypes: ${[ for (Parameter parameter in parameters) parameter.dataType ]}\n"
      "required: ${[ for (Parameter parameter in parameters) parameter.isRequired ]}\n"
      "optional: ${[ for (Parameter parameter in parameters) parameter.isOptional ]}\n"
      "positional: ${[ for (Parameter parameter in parameters) parameter.isPositional ]}\n"
      "optionalPositional: ${[ for (Parameter parameter in parameters) parameter.isOptionalPositional ]}\n"
      "named: ${[ for (Parameter parameter in parameters) parameter.isNamed ]}\n"
      "hasDefaultValue: ${[ for (Parameter parameter in parameters) parameter.hasDefaultValue ]}\n"
      "defaultValue: ${[ for (Parameter parameter in parameters) parameter.defaultValue ]}\n"
      "isNullable: ${[ for (Parameter parameter in parameters) parameter.isNullable ]}\n";

  bool get hasParameters => method.parameters.isNotEmpty;
  bool get hasNamedParameters => method.parameters.any((parameter) => parameter.isNamed);
  bool get hasPositionalParameters => method.parameters.any((parameter) => !parameter.isNamed);


  List<String> get parametersNames => parametersMirrors
      .map((parameter) => MirrorSystem.getName(parameter.simpleName))
      .toList();

  List<String> get _parametersTexts => [
        ..._positionalParameters(),
        ..._optionalPositionalParameters(),
        ..._namedParameters()
      ].withoutEmptyStrings();

  List<String> _positionalParameters() {
    List<String> optionalPositionalParameters = _optionalPositionalParameters();
    List<String> namedParameters = _namedParameters();

    if (parametersDeclaration == "()") return [];
    if (optionalPositionalParameters.length == parametersNames.length)
      return [];
    if (namedParameters.length == parametersNames.length) return [];

    int endingIndex = parametersDeclaration.length - 1;

    for (int i = 0; i < parametersDeclaration.length - 1; i++) {
      if (parametersDeclaration.at(i) == "," &&
          (parametersDeclaration.at(i + 1) == "[" ||
              parametersDeclaration.at(i + 1) == "{")) {
        endingIndex = i;
      }
    }

    return _splitParameters(parametersDeclaration.substring(1, endingIndex))
        .withoutEmptyStrings()
        .map((parameter) => "Positional::$parameter")
        .toList();
  }


  List<String> _optionalPositionalParameters() =>
      _getParametersEnclosedIn("[", "]")
          .map((parameter) => "OptionalPositional::$parameter")
          .toList();


  List<String> _namedParameters() =>
      _getParametersEnclosedIn("{", "}")
      .map((parameter) => "Named::$parameter")
      .toList();


  List<String> _getParametersEnclosedIn(
      String openingDelimiter,
      String closingDelimiter,
      ) {
    int openingDelimitersAmount = 0;
    int closingDelimitersAmount = 0;
    int splitStart = 0;
    for (int i = 0; i < parametersDeclaration.length; i++) {
      if (parametersDeclaration.at(i).isEqualTo(openingDelimiter))
        openingDelimitersAmount++;
      if (parametersDeclaration.at(i).isEqualTo(closingDelimiter))
        closingDelimitersAmount++;

      // if it is the first opening delimiter met, save the starting index
      if (parametersDeclaration.at(i).isEqualTo(openingDelimiter) &&
          splitStart.isEqualTo(0)) splitStart = i + 1;

      if (openingDelimitersAmount.isEqualTo(closingDelimitersAmount) &&
          openingDelimitersAmount > 0)
        return _splitParameters(parametersDeclaration.substring(splitStart, i))
            .withoutEmptyStrings();
    }

    return [];
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

  bool _thereIsEqualSignIn(String parameter) => parameter.indexOf("=") > 0;

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