import 'dart:mirrors';

import '../utils.dart';

export 'annotations/logged.dart';

class _LoggerMethod {
  MethodMirror method;
  bool hasNoParameters;
  bool isNoConstructor;
  bool hasLoggedAnnotation;
  bool isNotPrivate;

  _LoggerMethod(this.method)
      : hasNoParameters = method.parameters.isEmpty,
        isNoConstructor = !method.isConstructor,
        hasLoggedAnnotation = method.metadata.isNotEmpty &&
            method.metadata[0].type.simpleName == #logged,
        isNotPrivate = !method.isPrivate;
}

/// ---
/// When a subclass instance of `Logger` superclass is created the `log()`
/// function runs and all the subclass instance methods which have the
/// `@logged()` annotation are invoked.
abstract class Logger {

  Logger() {
    log();
  }

  /// ---
  /// Log and run all the methods with the `@logged` annotation.
  void log() {
    InstanceMirror im = reflect(this);
    for (var methodMirror in getMethods(im)) {
      _LoggerMethod method = _LoggerMethod(methodMirror);
      if (method.hasNoParameters &&
          method.isNotPrivate &&
          method.hasLoggedAnnotation &&
          method.isNotPrivate) {
        final beautifier = MethodLogBeautifier(methodMirror);
        print(beautifier.showLog().logMessage);
        im.invoke(methodMirror.simpleName, []);
      }
    }
  }
}
