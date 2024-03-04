import 'dart:mirrors';

import 'NamedParametersRequiredException.dart';
import 'PositionalParametersRequiredException.dart';
import 'TypePassedException.dart';

typedef MethodsPositionalArguments = Map<Symbol, List<dynamic>>;
typedef MethodsNamedArguments = Map<Symbol, Map<Symbol, dynamic>>;

// ? 'Object' and not 'dynamic' to avoid 'null' initialization
class RunningManager<T extends Object> {
  late final T _realInstance;
  late final InstanceMirror _instanceMirror;
  final List<Symbol> _instanceRunnableMethods = [];
  final List<Symbol> _allInstanceRunnableMethods = [];
  final Map<Symbol, Function> _annotations = {};

  RunningManager(T passedInstance) {
    InstanceMirror instance = reflect(passedInstance);

    if (instance.reflectee.runtimeType == Type)
      throw TypePassedException(passedInstance.toString());

    _instanceMirror = instance;
    _realInstance = instance.reflectee;

    // ? used 'declarations' instead of 'instanceMembers' to omit methods like 'toString()'
    // ? or 'noSuchMethod()' or operators like '=='.
    instance.type.declarations.forEach((symbol, declaration) {
      if (declaration is MethodMirror &&
          declaration.isRegularMethod &&
          !declaration.isOperator) {
        _allInstanceRunnableMethods.add(symbol);
        if (!declaration.isStatic) _instanceRunnableMethods.add(symbol);
      }
    });
  }

  void defineAnnotationFunctionality(
    Symbol annotationSymbol,
    Function(T, ClassMirror) annotationFunctionality,
  ) {
    final functionality = () {
      annotationFunctionality(_realInstance, _instanceMirror.type);
    };
    _annotations[annotationSymbol] = functionality;
  }

  void executionOrder() {}

  void defineGeneralInit() {}

  void defineGeneralDispose() {}

  void defineInitTo() {}

  void defineDisposeTo() {}

  void annotationRun() {}

  Map<Symbol, dynamic> simpleGeneralRun({
    MethodsPositionalArguments positionals = const {},
    MethodsNamedArguments named = const {},
  }) {

    Map<Symbol, dynamic> results = {};

    print("positionals = $positionals"); // * debug
    print("named = $named"); // * debug

    // TODO: check for optional and nullable parameters...
    _instanceRunnableMethods.forEach((methodSymbol) {

      final method =
          _instanceMirror.type.declarations[methodSymbol] as MethodMirror;

      print(method.simpleName);
      print(method.parameters.where((parameter) => parameter.isOptional));
      // It the method has parameters...
      if (method.parameters.isNotEmpty) {

        // if the method requires positional arguments...
        positionalParametersMatch(method, positionals[methodSymbol]);
        // if the method requires named arguments...
        // namedParametersMatch(method, named[methodSymbol]);
        // if (methodHasNamedArguments(method) && named[methodSymbol] == null)
          // throw NamedParametersRequiredException(method);
        namedParametersMatch(method, named[methodSymbol]);


        results[methodSymbol] = _instanceMirror
            .invoke(methodSymbol, positionals[methodSymbol] ?? [],
                named[methodSymbol] ?? {})
            .reflectee;
        // if the method returns something...
      } else if (method.returnType.hasReflectedType) {
        results[methodSymbol] =
            _instanceMirror.invoke(methodSymbol, []).reflectee;
        // if the method doesn't have parameters nor returns...
      } else {
        _instanceMirror.invoke(methodSymbol, []);
      }
      ;
    });

    return results;
  }

  void annotationGeneralRun() {}

  Map<Symbol, Function> get annotations => _annotations;

  T get realInstance => _realInstance;

  InstanceMirror get instanceMirror => _instanceMirror;


}

bool hasPositionalParameters(MethodMirror method) => method.parameters.any((parameter) => !parameter.isNamed);
bool hasNamedParameters(MethodMirror method) => method.parameters.any((parameter) => parameter.isNamed);

void positionalParametersMatch(MethodMirror method, List? passedPositionals) {
  if (hasPositionalParameters(method)) {
    if (passedPositionals == null) throw PositionalParametersRequiredException(method);
    positionalParametersTypeMatch(method, passedPositionals);
  }
}

void positionalParametersTypeMatch(MethodMirror method, List<dynamic> passedPositionals) {
  final methodPositionalParameters = method.parameters.where((parameter) => !parameter.isNamed).toList();
  if (methodPositionalParameters.length != passedPositionals.length)
    throw Exception("Positional parameters length mismatch. '${MirrorSystem.getName(method.simpleName)}' requires ${methodPositionalParameters.length} parameters, but ${passedPositionals.length} have been passed");
  for (int i = 0; i < methodPositionalParameters.length; i++) {
    if (methodPositionalParameters[i].type.reflectedType != passedPositionals[i].runtimeType) {
      throw Exception("Positional parameters type mismatch, '${MirrorSystem.getName(method.simpleName)}' requires ${methodPositionalParameters.map((parameter) => parameter.type.reflectedType)} parameters, but ${passedPositionals.map((positional) => positional.runtimeType)} have been passed");
    }
  }
}




void namedParametersMatch(MethodMirror method, Map<Symbol, dynamic>? passedNamed) {
  if (hasNamedParameters(method)) {
    if (passedNamed == null) throw NamedParametersRequiredException(method);
    namedParametersTypeMatch(method, passedNamed);
  }
}

void namedParametersTypeMatch(MethodMirror method, Map<Symbol, dynamic> passedNamed) {
  final methodNamedParameters = method.parameters.where((parameter) => parameter.isNamed);
  print("methodNamedParameters: $methodNamedParameters");
  if (methodNamedParameters.length != passedNamed.length)
    throw Exception("Named parameters length mismatch. '${MirrorSystem.getName(method.simpleName)}' requires ${methodNamedParameters.length} parameters, but ${passedNamed.length} have been given.");
  for (ParameterMirror parameter in methodNamedParameters) {
    if (passedNamed[parameter.simpleName] == null)
      throw Exception("'${MirrorSystem.getName(method.simpleName)}' requires named argument (${parameter.type.reflectedType} ${MirrorSystem.getName(parameter.simpleName)}), but it hasn't been supplied.");
  }
}
