import 'dart:mirrors';

abstract class ParametersException implements Exception {

  final MethodMirror method;

  ParametersException(this.method);

  @override
  String toString();

}