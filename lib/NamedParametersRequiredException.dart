import 'dart:mirrors';

import 'ParametersException.dart';

class NamedParametersRequiredException extends ParametersException {

  NamedParametersRequiredException(super.method);

  @override
  String toString() => "NamedParametersRequiredException: Method '${MirrorSystem.getName(method.simpleName)}' requires ${method.parameters.map((parameter) => "${parameter.type.reflectedType} ${MirrorSystem.getName(parameter.simpleName)}")} named arguments but there is no match in the passed arguments.";

}