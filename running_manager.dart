import 'dart:mirrors';


class RunningManager<T extends Object> {
  // ? 'Object' and not 'dynamic' to avoid 'null' initialization
  late final T _realInstance;
  late final InstanceMirror _instanceMirror;
  late final List<Symbol> _instanceRunnableMethods;
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
      if (declaration is MethodMirror && declaration.isRegularMethod && !declaration.isOperator) print(declaration);
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
  void simpleRun() {}
  void annotationRun() {}
  void simpleGeneralRun() {}
  void annotationGeneralRun() {}

  Map<Symbol, Function> get annotations => _annotations;

  T get realInstance => _realInstance;

  InstanceMirror get instanceMirror => _instanceMirror;
}

