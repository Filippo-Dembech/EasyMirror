library runner;

import 'dart:mirrors';

import '../utils.dart';

import 'annotations/helper.dart';
import 'annotations/run.dart';

// TODO: encapsulate this class only inside the runner library

// ? Since we can't hide this class to the other packages it might
// ? as well make it un-inheritable with the `final` keyword.
final class RunnerMethod {
  /// ---
  /// The `MethodMirror` instance associated with the current
  /// `_RunnerMethod` instance.
  MethodMirror methodMirror;

  /// ---
  /// `true` when the method the `MethodMirror` instance reflects
  /// on isn't a constructor.
  bool isNoConstructor;

  /// ---
  /// `true` when the method the `MethodMirror` instance reflects
  /// on has no parameters.
  bool hasNoParameters;

  /// ---
  /// `true` when the method the `MethodMirror` instance reflects
  /// on is not a private.
  bool isNotPrivate;

  /// ---
  /// `true` when the name of the method the `MethodMirror` instance
  /// reflects on contains the word `helper`. Note that the checking isn't case
  /// sensitive, for example, `helperFunction`, `funHelper`,
  /// `sampleHelperFunction`, would all match the criteria.
  bool containsHelper;

  /// ---
  /// `true` when the method the `MethodMirror` instance reflects
  /// on is annotated with the `@helper()` annotation.
  bool hasHelperAnnotation;

  /// ---
  /// `true` when the method the `MethodMirror` instance reflects
  /// on is annotated with the `@helper(run: true)` annotation.
  bool hasHelperRunAnnotation;

  /// ---
  /// The name of the method the `MethodMirror` instance
  /// reflects on.
  String name;

  /// ---
  /// `true` if the method the `MethodMirror` instance reflects
  /// on is annotated with the `@run()` annotation.
  bool hasRunAnnotation;

  /// ---
  /// `Runner` helper class to find characteristics of the method
  /// the passed `MethodMirror` instance refers to.
  RunnerMethod(this.methodMirror)
      : name = getMethodName(methodMirror),
        isNoConstructor = !methodMirror.isConstructor,
        hasNoParameters = methodMirror.parameters.isEmpty,
        isNotPrivate = !methodMirror.isPrivate,
        containsHelper =
            getMethodName(methodMirror).toLowerCase().contains("helper"),
        hasHelperAnnotation = methodMirror.metadata
            .where((metadata) => metadata.reflectee.runtimeType == helper)
            .isNotEmpty,
        hasHelperRunAnnotation = methodMirror.metadata
                .where((metadata) => metadata.reflectee.runtimeType == helper)
                .isNotEmpty &&
            methodMirror.metadata
                    .where(
                        (metadata) => metadata.reflectee.runtimeType == helper)
                    .toList()[0]
                    .getField(#run)
                    .reflectee ==
                true,
        hasRunAnnotation = methodMirror.metadata
            .where((metadata) => metadata.reflectee.runtimeType == run)
            .isNotEmpty;
}
