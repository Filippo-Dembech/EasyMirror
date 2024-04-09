import 'dart:mirrors';

import '../ConstructorException.dart';
import '../PositionalParametersRequiredException.dart';
import 'Extensions/list__empty_string_remover.dart';
import 'Extensions/object__equal_objects.dart';
import 'Extensions/string__element_fetcher.dart';
import 'parameter_extractor.dart';
import 'parameter_type.dart';


class Parameter {
  final String name;
  final String dataType;
  final bool isPositional;
  final bool isOptionalPositional;
  final bool isNamed;
  final bool isOptional;
  final bool isRequired;
  final bool hasDefaultValue;
  final bool isNullable;
  final ParameterType type;
  final String? defaultValue;

  const Parameter({
    required this.name,
    required this.dataType,
    required this.type,
    this.isPositional = false,
    this.isOptionalPositional = false,
    this.isNamed = false,
    this.isRequired = false,
    this.hasDefaultValue = false,
    this.defaultValue,
    this.isNullable = false,
  }) : isOptional = !isRequired;

  @override
  String toString() => "(#${type.value}# ${(isNamed && isRequired) ? "required " : ""}$dataType $name${defaultValue ?? ""})";
}

class MethodAnalyzer {
  // TODO: make 'method' private
  final MethodMirror method;
  late String _parametersString;
  late List<ParameterMirror> _parametersMirrors;

  int getParametersStartingIndexIn(String source) {
    int methodNameIndex = source.indexOf(name + "(");
    return methodNameIndex + name.length;
  }

  MethodAnalyzer(this.method) {
    if (method.isConstructor) throw ConstructorException();

    // ! '_parametersString' is computed here because it is
    // ! used in other methods and computing it every single
    // ! time slows execution down
    ParametersExtractor parametersExtractor = ParametersExtractor(source, name);
    _parametersString = parametersExtractor.parameters;

    _parametersMirrors = method.parameters;
  }

  String get name => MirrorSystem.getName(method.simpleName);

  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => _parametersMirrors;

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

  bool hasParameters() => method.parameters.isNotEmpty;
  bool hasNamedParameters() => method.parameters.any((parameter) => parameter.isNamed);
  bool hasPositionalParameters() => method.parameters.any((parameter) => !parameter.isNamed);

  String get parametersDeclaration => _parametersString;

  List<String> get parametersNames => parametersMirrors
      .map((parameter) => MirrorSystem.getName(parameter.simpleName))
      .toList();

  List<String> get parametersTexts => [
        ...positionalParameters,
        ...optionalPositionalParameters,
        ...namedParameters
      ].withoutEmptyStrings();

  List<String> get positionalParameters => _positionalParameters();

  List<String> get namedParameters => _namedParameters();

  List<String> get optionalPositionalParameters =>
      _optionalPositionalParameters();

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
      _getEnclosedParameters("[", "]")
          .map((parameter) => "OptionalPositional::$parameter")
          .toList();

  List<String> _namedParameters() => _getEnclosedParameters("{", "}")
      .map((parameter) => "Named::$parameter")
      .toList();

  List<String> get parametersDataTypes => _parametersDataTypes();

  List<String> _parametersDataTypes() {
    List<String> result = [];
    for (int i = 0; i < parametersTexts.length; i++) {
      String parameterText = parametersTexts[i];
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

  List<String> get parametersDefaults => _parametersDefaults();

  List<String> _parametersDefaults() {
    List<String> result = [];

    for (String parameter in parametersTexts) {
      int equalSignIndex = parameter.indexOf("=");
      String defaultDeclaration = "";
      if (_thereIsEqualSignIn(parameter))
        defaultDeclaration = " = ${parameter.substring(equalSignIndex + 1)}";
      result.add(defaultDeclaration);
    }

    return result;
  }

  bool _thereIsEqualSignIn(String parameter) => parameter.indexOf("=") > 0;

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

  List<String> get parametersDeclarations => _parametersDeclarations();

  List<String> _parametersDeclarations() {
    List<String> result = [];
    for (int i = 0; i < parametersTexts.length; i++) {
      result.add(
          "${parametersTexts[i].split("::")[0]}::${parametersDataTypes[i]} ${parametersNames[i]}${parametersDefaults[i]}");
    }
    return result;
  }

  List<String> _getEnclosedParameters(
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