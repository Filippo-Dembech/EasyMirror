import 'parameter_type.dart';

class Parameter {
  /// The [name] of this parameter.
  final String name;

  /// The [dataType] of this parameter.
  final String dataType;

  /// Whether this parameter is a positional parameter.
  final bool isPositional;

  /// Whether this parameter is an optional positional parameter.
  final bool isOptionalPositional;

  /// Whether this parameter is a named parameter.
  final bool isNamed;

  /// Whether this parameter is optional.
  final bool isOptional;

  /// Whether this parameter is required.
  final bool isRequired;

  /// Whether this parameter has some default value.
  final bool hasDefaultValue;

  /// Whether this parameter is nullable.
  final bool isNullable;

  /// The [ParameterType] of this parameter.
  final ParameterType type;

  /// The default value of this parameter, if any.
  /// If no default parameter is present, `null` is
  /// returned.
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
  bool operator ==(Object other) => 
    identical(this, other) ||
    other is Parameter &&
    runtimeType == other.runtimeType &&
    name == other.name &&
    dataType == other.dataType &&
    type == other.type &&
    isPositional == other.isPositional &&
    isOptionalPositional == other.isOptionalPositional &&
    isNamed == other.isNamed &&
    isRequired == other.isRequired &&
    hasDefaultValue == other.hasDefaultValue &&
    defaultValue == other.defaultValue &&
    isNullable == other.isNullable;

  @override
  int get hashCode =>
    name.hashCode ^
    dataType.hashCode ^
    type.hashCode ^
    isPositional.hashCode ^
    isOptionalPositional.hashCode ^
    isNamed.hashCode ^
    isRequired.hashCode ^
    hasDefaultValue.hashCode ^
    defaultValue.hashCode ^
    isNullable.hashCode;

  @override
  String toString() => "(#${type.value}# ${(isNamed && isRequired) ? "required " : ""}$dataType $name${defaultValue ?? ""})";
}