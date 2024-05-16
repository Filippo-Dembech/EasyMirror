enum ParameterType {

  positional("POSITIONAL"),
  optionalPositional("OPTIONAL_POSITIONAL"),
  named("NAMED");

  final String value;

  const ParameterType(this.value);
}
