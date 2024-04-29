library runner;

import 'dart:mirrors';

import '../utils.dart';
import 'runner_method.dart';


export 'annotations/run.dart';
export 'annotations/helper.dart';

// TODO: subclasses methods names can't be "helper()" nor "run()" (ERROR: Annotation must be either a const variable reference or const constructor invocation.)

/// ---
/// # Runner Class 👟
/// Run all non-helper methods of the class that extends it.
/// A method is defined as _helper_ if it has the `@helper()`
/// annotation or if it contains the word `helper` in its
/// method name.
/// ---
/// # Run also helper methods 🤔
/// In order to run also the helper methods, in the constructor
/// declaration pass `alsoHelpers: true` to the `super` constructor.
/// For example, if the subclass extending `Runner` is called `Test`,
/// then the constructor declaration to use in order to run also
/// the helper methods is:
/// ```dart
/// class Test extends Runner {
///   Test() : super(alsoHelpers: true);
///   // ...
/// }
/// ```
/// ---
/// # Run specific helper methods 📌
/// ## First Method
/// Passing `run: true` to the `@helper()` annotation
/// enforces the helper method to be treated as a normal
/// method.<br>
/// Example:
/// ```dart
/// @helper(run: true)
/// void sampleMethod() {
///   // ...
/// }
/// ```
/// ## Second Method
/// Annotate the method with the `@run()` annotation
/// to mark it as a normal method.<br>
/// Example:
/// ```dart
/// @run()
/// void sampleMethod() {
///   // ...
/// }
/// ```
/// Helper `sampleMethod()` will be treated as a normal method.
/// ---
/// # Show methods names 👁️
/// Pass `showMethodsNames: true` to the `super` constructor. For
/// example, if the class extending `Runner` is called `Test` then
/// the `super` constructor declaration in order to show the metohds
/// names should be:
/// ```dart
/// class Test extends Runner {
///   Test() : super(showMethodsNames: true);
///   // ...
/// }
/// ```
abstract class Runner {
  bool _runAlsoHelpers;
  bool _showMethodsNames;

  Runner({bool runAlsoHelpers = false, bool showMethodsNames = false})
      : _runAlsoHelpers = runAlsoHelpers,
        _showMethodsNames = showMethodsNames {
    _run();
  }

  /// ---
  /// Runs all the non-helper methods of the class.
  /// ---
  /// __NOTE__: it is `private` to prevent stack overflow exception when called within a subclass method
  void _run() {
    InstanceMirror im = reflect(this);
    for (var methodMirror in getMethods(im)) {
      RunnerMethod method = RunnerMethod(methodMirror);
      if (method.isNoConstructor &&
          method.hasNoParameters &&
          method.isNotPrivate) {
        // used Karnaugh Maps on containsHelper, _runAlsoHelpers and hasHelperAnnotation,
        // hasRunAnnotation and hasHelperRunAnnotation on the negative output to get the
        // reduced conditional form and then use DeMorgan Laws to remove general negation.
        if (method.hasRunAnnotation ||
            !((!_runAlsoHelpers && !method.hasHelperRunAnnotation) &&
                (method.containsHelper ||
                    (method.hasHelperAnnotation && !method.containsHelper)))) {
          if (_showMethodsNames) {
            final beautifier = MethodLogBeautifier(methodMirror);
            print(beautifier.logMessage);
          }
          im.invoke(methodMirror.simpleName, []);
        }
      }
    }
  }
}
