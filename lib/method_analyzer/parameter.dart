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