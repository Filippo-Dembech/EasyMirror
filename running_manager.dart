import 'dart:mirrors';

class RunningManager<T extends Object> {
  // ? 'Object' and not 'dynamic' to avoid 'null' initialization
  late final T _realInstance;
  late final InstanceMirror _instanceMirror;
  final List<Symbol> _instanceRunnableMethods = [];
  final List<Symbol> _allIstanceRunnableMethods = [];
  final Map<Symbol, Function> _annotations = {};

  RunningManager(T passedInstance) {
    InstanceMirror instance = reflect(passedInstance);
    if (instance.reflectee.runtimeType == Type)
      throw Exception("can't pass generic Type, class instance must be passed");

    _instanceMirror = instance;
    _realInstance = instance.reflectee;

    // ? used 'declarations' instead of 'instanceMembers' to omit methods like 'toString()'
    // ? or 'noSuchMethod()' or operators like '=='.
    instance.type.declarations.forEach((symbol, declaration) {
      if (declaration is MethodMirror &&
          declaration.isRegularMethod &&
          !declaration.isOperator) {
        _allIstanceRunnableMethods.add(symbol);
        if (!declaration.isStatic) _instanceRunnableMethods.add(symbol);
      }
    });
  }

  void defineAnnotationFunctionality(
    Symbol annotation,
    Function(T, ClassMirror) f,
  ) {
    final functionality = () {
      f(_realInstance, _instanceMirror.type);
    };
    _annotations[annotation] = functionality;
  }

  void executionOrder() {}

  void defineGeneralInit() {}

  void defineGeneralDispose() {}

  void defineInitTo() {}

  void defineDisposeTo() {}

  void annotationRun() {}

  Map<Symbol, dynamic> simpleGeneralRun(
      {Map<Symbol, List<dynamic>> positionals = const <Symbol, List<dynamic>>{},
      Map<Symbol, Map<Symbol, dynamic>> named = const <Symbol, Map<Symbol, dynamic>>{}}) {

    Map<Symbol, dynamic> result = {};

    print("positionals = $positionals");
    print("named = $named");

    // TODO: check for optional and nullable parameters...
    _instanceRunnableMethods.forEach((methodSymbol) {
      final method = _instanceMirror.type.declarations[methodSymbol] as MethodMirror;
      // It the method has parameters...
      if (method.parameters.isNotEmpty) {
        // if the method requires positional arguments...
        if (!methodHasNamedArguments(method) && positionals[methodSymbol] == null) throw Exception("Method '${MirrorSystem.getName(methodSymbol)}' requires ${method.parameters.map((parameter) => parameter.type.reflectedType)}  positional arguments but there is no match in the passed arguments.");
        // if the method requires named arguments...
        if (methodHasNamedArguments(method) && named[methodSymbol] == null) throw Exception("Method '${MirrorSystem.getName(methodSymbol)}' requires ${method.parameters.map((parameter) => "${parameter.type.reflectedType} ${MirrorSystem.getName(parameter.simpleName)}")} named arguments but there is no match in the passed arguments.");
        result[methodSymbol] = _instanceMirror.invoke(methodSymbol, positionals[methodSymbol] ?? [], named[methodSymbol] ?? {}).reflectee;
        // if the method returns something...
      } else if (method.returnType.hasReflectedType) {
        result[methodSymbol] = _instanceMirror.invoke(methodSymbol, []).reflectee;
        // if the method doesn't have parameters nor returns...
      } else {
        _instanceMirror.invoke(methodSymbol, []);
      };
    });

    return result;
  }

  void annotationGeneralRun() {}

  Map<Symbol, Function> get annotations => _annotations;

  T get realInstance => _realInstance;

  InstanceMirror get instanceMirror => _instanceMirror;
}


bool methodHasNamedArguments(MethodMirror method) => method.parameters.any((parameter) => parameter.isNamed);
bool methodHasPostionalArguments(MethodMirror method) => method.parameters.any((parameter) => parameter.isTopLevel);