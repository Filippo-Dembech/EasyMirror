import 'package:easy_mirror/easy_mirror.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/list__empty_string_remover.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/object__equal_objects.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/string__element_fetcher.dart';
import 'package:easy_mirror/src/method_analyzer/extensions/string_whitespaces_remover.dart';

class ParametersTypeSplitter {
  late String _parametersDeclaration;

  List<Map<String, dynamic>> separates(String parametersDeclaration) {
    _parametersDeclaration = parametersDeclaration.withoutWhiteSpaces();
    if (parametersDeclaration.isEmpty) return [];

    return _parametersTexts;
  }

  List<Map<String, dynamic>> get _parametersTexts => [
        ..._positionalParameters(),
        ..._optionalPositionalParameters(),
        ..._namedParameters(),
      ];


  List<Map<String, dynamic>> _positionalParameters() {
    if (_thereAreNoParameters() ||
        _thereAreOnlyOptionalPositionalParameters() ||
        _thereAreOnlyNamedParameters()) return [];

    int endingIndex = _getPositionalParametersEndingIndex();

    String parameters = _parametersDeclaration
                          .substring(0, endingIndex);
    final splitter = SkipBoundSplitter(parameters, separator: ",")..ignoringSeparatorsWithin({Delimiters.ROUND_BRACKETS, Delimiters.DIAMOND_BRACKETS});
    List<String> splitParameters = splitter.splits();

    return splitParameters
        .map((parameter) => {"type": ParameterType.positional, "text": parameter.withoutWhiteSpaces() })
        .toList();
  }

  bool _thereAreNoParameters() => _parametersDeclaration.isEmpty;
  bool _thereAreOnlyOptionalPositionalParameters() => _parametersDeclaration.startsWith("[");
  bool _thereAreOnlyNamedParameters() => _parametersDeclaration.startsWith("{");

  int _getPositionalParametersEndingIndex() {
    int endingIndex = _parametersDeclaration.length;
    for (int i = 0; i < endingIndex - 1; i++) {
      if (_optionalPositionalParametersStartAt(i) ||
          _namedParametersStartAt(i)) {
        endingIndex = i;
      }
    }
    return endingIndex;
  }

  bool _optionalPositionalParametersStartAt(int i) =>
    _parametersDeclaration.at(i) == "," &&
    _parametersDeclaration.at(i + 1) == "[";

  bool _namedParametersStartAt(int i) =>
    _parametersDeclaration.at(i) == "," &&
    _parametersDeclaration.at(i + 1) == "{";

  List<Map<String, dynamic>> _optionalPositionalParameters() =>
      _getParametersEnclosedIn(Delimiters.SQUARED_BRACKETS)
          .map((parameter) => {"type": ParameterType.optionalPositional, "text": parameter.withoutWhiteSpaces()})
          .toList();

  List<Map<String, dynamic>> _namedParameters() =>
      _getParametersEnclosedIn(Delimiters.CURLY_BRACKETS)
          .map((parameter) => {"type": ParameterType.named, "text": parameter.withoutWhiteSpaces()})
          .toList();

  List<String> _getParametersEnclosedIn(Delimiters delimiters) {
    String parameters =
        StringExtractor.parsing(_parametersDeclaration)
            .extractsFirstStringWithin(delimiters);
    final splitter = SkipBoundSplitter(parameters, separator: ",")
            ..ignoringSeparatorsWithin({Delimiters.ROUND_BRACKETS, Delimiters.DIAMOND_BRACKETS});;
    return splitter.splits().withoutEmptyStrings();
  }

}