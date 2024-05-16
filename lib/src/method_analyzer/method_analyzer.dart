import 'dart:mirrors';

import 'package:easy_mirror/src/method_analyzer/parameters_separator/parameters_type_splitter.dart';

import 'constructor_exception.dart';
import 'extensions/list__empty_string_remover.dart';
import 'extensions/object__equal_objects.dart';
import 'extensions/string__element_fetcher.dart';
import 'extensions/string_whitespaces_remover.dart';
import 'parameter.dart';
import 'parameter_type.dart';
import 'string_extractor/delimiters.dart';
import 'string_extractor/string_extractor.dart';
import 'temp/parameters_reporter.dart';

class MethodAnalyzer {
  // TODO: make 'method' private
  // TODO: if the source code has new lines 'index: invalid value' error is returned
  // TODO: remove all the '.withoutEmptyStrings()'
  MethodMirror method;
  /// 
  late String _sourceParametersDeclaration;
  List<ParameterMirror> _parametersMirrors;

  MethodAnalyzer(this.method) : _parametersMirrors = method.parameters {
    if (method.isConstructor) throw ConstructorException();

    // ! '_parametersDeclarationWithoutSpaces' is computed here because it is
    // ! used in other methods and computing it every single
    // ! time slows execution down
    // ! withoutWhiteSpaces() because it makes it easier to use string patterns throughout
    // ! the entire codebase without the worry to consider them.
    _sourceParametersDeclaration = _extractParametersDeclarationFrom(source);
    // print(_sourceParametersDeclaration); // * DEBUG
  }

  String _extractParametersDeclarationFrom(String source) {
    int methodNameIndex = source.indexOf(methodName + "(");
    String leftTrimSource =
        source.substring(methodNameIndex + methodName.length);
    return StringExtractor
            .parsing(leftTrimSource)
            .extractsFirstStringWithin(Delimiters.ROUND_BRACKETS)
            .withoutWhiteSpaces();
  }

  String get methodName => MirrorSystem.getName(method.simpleName);

  String get source => method.source!;

  List<ParameterMirror> get parametersMirrors => _parametersMirrors;

  String get parametersReport => ParametersReporter().reports(this.parameters);

  List<Parameter> get parameters {
    List<Parameter> result = [];
    for (String parameter in parametersDeclarations) {
      //print("source: $_sourceParametersDeclaration"); // * DEBUG
      //print("parameter: $parameter"); //* DEBUG
      String parameterType = parameter.split("::")[0];
      String parameterDeclaration = parameter.split("::")[1];
      String parameterDataType = parameterDeclaration.split(" ")[0];
      String parameterName = parameterDeclaration.split(" ")[1];
      String? defaultValue;
      int equalSignIndex = parameter.indexOf("=");
      if (_thereIsEqualSignIn(parameter)) {
        defaultValue = parameter
          .substring(equalSignIndex + 2)
          .replaceAll("\"", "");  // ! replaceAll() because the 'source' returned by the method mirror keeps quotes "" as characters
      }
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

      if (parameterType == "POSITIONAL") isRequired = true;

      if (_thereIsEqualSignIn(parameter)) hasDefaultValue = true;
      if (parameter.startsWith("NAMED")) {
        isNamed = true;
        type = ParameterType.named;
      }
      if (parameter.startsWith("OPTIONAL_POSITIONAL")) {
        isOptionalPositional = true;
        type = ParameterType.optionalPositional;
      }
      if (parameter.startsWith("POSITIONAL")) {
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
    for (int i = 0; i < _parametersTexts.length; i++) {
      result.add("${_parametersTexts[i]["type"].value}::${_parametersDataTypes()[i]} ${parametersNames[i]}${parametersDefaults[i]}");
    }
    return result;
  }


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


  // TODO: replace _splitParameters() method with StringSplitter
// ! parameters list must be without opening "(" and closing ")"

  List<String> get parametersDefaults => _parametersDefaults();

  List<String> _parametersDefaults() {
    List<String> result = [];

    for (Map<String, dynamic> parameter in _parametersTexts) {
      int equalSignIndex = parameter["text"].indexOf("=");
      String defaultDeclaration = "";
      if (_thereIsEqualSignIn(parameter["text"]))
        defaultDeclaration = " = ${parameter["text"].substring(equalSignIndex + 1)}";
      result.add(defaultDeclaration);
    }

    return result;
  }


  bool _thereIsEqualSignIn(String parameter) => parameter.contains("=");


  List<String> _parametersDataTypes() {
    List<String> result = [];
    // print("parameterNames: $parametersNames"); // * DEBUG
    // print("parametersTexts: $_parametersTexts"); // * DEBUG
    // print("parametersTexts.length: ${_parametersTexts.length}"); // * DEBUG
    for (int i = 0; i < _parametersTexts.length; i++) {
      String parameterText = _parametersTexts[i]["text"];
      // print("parameter text: $parameterText"); // * DEBUG
      String parameterName = parametersNames[i];
      String parameterDataType;
      if (_thereIsEqualSignIn(parameterText)) {
        String textBeforeEqualSign = parameterText.split("=")[0];
        parameterDataType = parameterText
          .substring(0, textBeforeEqualSign.length - parameterName.length);
      } else {
        parameterDataType = parameterText
          .substring(0, parameterText.length - parameterName.length);
      }

      // print("parameterDataType: $parameterDataType"); // * DEBUG

      if (parameterDataType.startsWith("required"))
        parameterDataType = "required ${parameterDataType.substring(8)}";

      result.add(parameterDataType);
    }
    return result;
  }

  List<Map<String,dynamic>> get _parametersTexts => ParametersTypeSplitter().separates(_sourceParametersDeclaration);
}