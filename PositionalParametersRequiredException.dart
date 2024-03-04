import 'dart:mirrors';

import 'ParametersException.dart';

class PositionalParametersRequiredException extends ParametersException {

  PositionalParametersRequiredException(super.method);

  @override
  String toString() => "PositionalParametersRequiredException: Method '${MirrorSystem.getName(method.simpleName)}' requires ${method.parameters.map((parameter) => parameter.type.reflectedType)} positional arguments but there is no match in the passed arguments.";
}