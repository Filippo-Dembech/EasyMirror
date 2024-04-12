import '../parameter.dart';

class ParametersReporter {
  List<Parameter> _parameters = [];

  String reports(List<Parameter> parameters) {
    _parameters = parameters;
    return ""
        "parameters: $_parameters\n"
        "names: ${_getParametersNames()}\n"
        "dataTypes: ${_getParametersDataTypes()}\n"
        "required: ${_getRequired()}\n"
        "optional: ${_getOptionals()}\n"
        "positional: ${_getPositionals()}\n"
        "optionalPositional: ${_getOptionalPositionals()}\n"
        "named: ${_getNamed()}\n"
        "hasDefaultValue: ${_getHasDefaultValue()}\n"
        "defaultValue: ${_getDefaultValues()}\n"
        "isNullable: ${_getIsNullable()}\n";
  }

  String _getParametersNames() {
    return "${[for (Parameter parameter in _parameters) parameter.name]}";
  }

  String _getParametersDataTypes() {
    return "${[for (Parameter parameter in _parameters) parameter.dataType]}";
  }

  String _getRequired() {
    return "${[for (Parameter parameter in _parameters) parameter.isRequired]}";
  }

  String _getOptionals() {
    return "${[for (Parameter parameter in _parameters) parameter.isOptional]}";
  }

  String _getPositionals() {
    return "${[
      for (Parameter parameter in _parameters) parameter.isPositional
    ]}";
  }

  String _getOptionalPositionals() {
    return "${[
      for (Parameter parameter in _parameters) parameter.isOptionalPositional
    ]}";
  }

  String _getNamed() {
    return "${[for (Parameter parameter in _parameters) parameter.isNamed]}";
  }

  String _getHasDefaultValue() {
    return "${[
      for (Parameter parameter in _parameters) parameter.hasDefaultValue
    ]}";
  }

  String _getDefaultValues() {
    return "${[
      for (Parameter parameter in _parameters) parameter.defaultValue
    ]}";
  }

  String _getIsNullable() {
    return "${[for (Parameter parameter in _parameters) parameter.isNullable]}";
  }
}
