import 'dart:mirrors';


/// ---
/// Return a list of `MethodMirror`s on the passed `InstanceMirror`'s methods.
List<MethodMirror> getMethods(InstanceMirror im) => im.type.declarations.values
    .where((declaration) => declaration is MethodMirror)
    .map((e) => e as MethodMirror)
    .toList();

/// ---
/// Return the `String` name of the passed `MethodMirror`.
String getMethodName(MethodMirror methodMirror) =>
    MirrorSystem.getName(methodMirror.simpleName);


// TODO: what if the user passes something that is not a method name?
/// ---
/// Return a colored and formatted `String` of the passed
/// method name.
String beautifyMethodLog(String methodLog) {
  return "${strMagenta(">>>")} "
      "${strBlue(methodLog)}"
      "${strCyan("()")} ... "
      "";
}

class MethodLogBeautifier {
  MethodMirror methodMirror;
  String _logMessage;

  MethodLogBeautifier(this.methodMirror)
      : _logMessage = beautifyMethodLog(
          getMethodName(methodMirror),
        );

  MethodLogBeautifier showLog() {
    if (methodMirror.metadata.isNotEmpty)
      _logMessage =
          "$logMessage ${strGreen(methodMirror.metadata[0].getField(#msg).reflectee)}";
    return this;
  }

  String get logMessage => _logMessage;
}


/// ---
/// Just a class for reflection testing purposes.
class Person {
  static int peopleCount = 0;

  static bool isCrowd() => peopleCount > 15;

  String _name;
  int _age;

  Person(this._name, this._age) {
    peopleCount++;
  }

  void talk() => print("$name is talking...");

  String wavingTo(String person) => "$name is waving to $person";

  @annotation("annotation string test")
  String liftWeight({double weight = 0}) => "$name is lifting $weight kg";

  void second() => print("second: this is the second method");

  void third() => print("third: this is the third method");

  bool isAdult() => age > 18;

  String get name => _name;

  int get age => _age;

  void set name(String name) {
    this._name = name;
  }

  void set age(int age) {
    this._age = age;
  }
}

String strBlack(String s) =>   "\x1B[30m$s\x1B[0m";
String strRed(String s) =>   "\x1B[31m$s\x1B[0m";
String strGreen(String s) =>   "\x1B[32m$s\x1B[0m";
String strYellow(String s) =>   "\x1B[33m$s\x1B[0m";
String strBlue(String s) =>   "\x1B[34m$s\x1B[0m";
String strMagenta(String s) =>   "\x1B[35m$s\x1B[0m";
String strCyan(String s) =>   "\x1B[36m$s\x1B[0m";
String strWhite(String s) =>   "\x1B[37m$s\x1B[0m";

/// ---
/// A simple annotation for testing purposes only.
/// It has a [message] property with which reflection
/// with parameterized annotation can be practiced.
class annotation {
  /// ---
  /// Optional parameters message passed to the `annotation`
  /// annotation, it is an empty `String` by defaut.
  final String message;
  const annotation([this.message = ""]);
}
