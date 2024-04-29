enum ParameterType {

  positional("POSITIONAL"),
  optionalPositional("OPTIONAL_POSITIONAL"),
  named("NAMED"),
  optionalNamed("OPTIONAL_NAMED");

  final String value;

  const ParameterType(this.value);
}
