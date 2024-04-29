import 'dart:mirrors';

import 'package:easy_mirror/src/method_analyzer/method_analyzer.dart';

class test {
  const test();
}

class Person {
  String _name;
  static int peopleAmount = 0;

  static int enrollPerson() => ++peopleAmount;

  static int expelPerson() => --peopleAmount;

  Person([this._name = "john doe"]);

  Person.eric() : _name = "eric";

  void get name => _name;

  @test()
  String scream(String sth) => sth.toUpperCase();

  void sayHello() {
    print("hello from person");
  }
}

class Generic<T, V, K> {}

class Test {
  // methods without parameters
  void a() {
    print("a");
  }

  // methods with positional parameters
  void b(int a, int b) {
    print("b");
  }

  // methods with optional positional parameters
  void c([int? optionalA, int? optionalB]) {
    print("c");
  }

  // methods with positional parameters and optional positional parameters
  void d(int a, int b, [int? optionalC, int? optionalD]) {
    print("d");
  }

  // methods with named parameters
  void e({int? namedA, int? namedD}) {
    print("e");
  }

  // methods with positional parameters and named parameters
  void f(int a, int b, {int? namedC, int? namedD}) {
    print("f");
  }

  // methods without parameters and returning value
  String g() => "a";
  // methods with positional parameters and returning value
  String h(int a, int b) => "b";
  // methods with optional positional parameters and returning value
  String i([int? optionalA, int? optionalB]) => "c";
  // methods with positional parameters and optional positional parameters and returning value
  String j(int a, int b, [int? optionalC, int? optionalD]) => "d";
  // methods with named parameters and returning value
  String k({int? namedA, int? namedD}) => "e";
  // methods with positional parameters and named parameters and returning value
  String l(int a, int b, {int? namedC, int? namedD}) => "f";

  // methods without parameters with generics
  Generic<String, int, int> m() => Generic();
  // methods with positional parameters with generics
  void n(Generic<String, int, int> a, int b) {
    print("b");
  }

  // methods with optional positional parameters with generics
  void o([int? optionalA, Generic<String, int, int>? optionalB]) {
    print("c");
  }

  // methods with positional parameters and optional positional parameters with generics
  void p(int a, Generic<String, int, int> b,
      [int? optionalC, Generic<String, int, int>? optionalD]) {
    print("d");
  }

  // methods with named parameters with generics
  void q({int? namedA, Generic<String, int, int>? namedD}) {
    print("e");
  }

  // methods with positional parameters and named parameters with generics
  void r(int a, Generic<String, int, int> b,
      {int? namedC, Generic<String, int, int>? namedD}) {
    print("f");
  }

  // methods without parameters and returning value with generics
  Generic<String, int, int> s() => Generic();
  // methods with positional parameters and returning value with generics
  Generic<String, int, int> t(Generic<String, int, int> a, int b) => Generic();
  // methods with optional positional parameters and returning value with generics
  Generic<String, int, int> u(
          [int? optionalA, Generic<String, int, int>? optionalB]) =>
      Generic();
  // methods with positional parameters and optional positional parameters and returning value with generics
  Generic<String, int, int> v(int a, Generic<String, int, int> b,
          [int? optionalC, Generic<String, int, int>? optionalD]) =>
      Generic();
  // methods with named parameters and returning value with generics
  Generic<String, int, int> x(
          {int? namedA, Generic<String, int, int>? namedD}) =>
      Generic();
  // methods with positional parameters and named parameters and returning value with generics
  Generic<String, int, int> y(int a, Generic<String, int, int> b,
          {int? namedC, Generic<String, int, int>? namedD}) =>
      Generic();

  // record parameters
  void z((String, int) a) {
    print("z");
  }

  // return record
  (String, int) A() => ("A", 1);
  // record and generic parameters
  void B((String, int) a, [Generic<String, int, int>? optionalB]) {
    print("B");
  }

  // return records and generics
  (Generic<String, int, int>, int) C() => (Generic(), 1);

  void D(int a, int b, {int? c, required int d}) {}
  void E(int a, Function(Generic<bool, int, int>) b,
      {int? c, required Function(int, int) d}) {}
  void F({required int a, required int b, required int c}) {}
  void G({int a = 2}) {}
  void H([int a = 2, int b = 3, int? c]) {}
  // ! BUG REPORT: 'isNullable: false' this is an error
  // ! BUG REPORT: 'defaultValue: [ = const[]]' const shouldn't be there
  void I({List<String>? names = const []}) {}
}

void main() {
  final a = reflect(Test());

  /*
  final method = MethodAnalyzer(a.type.declarations[#f] as MethodMirror);
  print("=============== ${method.name} ===============");
  print("named parameters: ${method.namedParameters}");
  print("parameters: ${method.parametersNames}");
  print("parameters list: ${method.parametersList}");
  */

  a.type.declarations.forEach((symbol, declaration) {
    if (declaration is MethodMirror && !declaration.isConstructor) {
      final method = MethodAnalyzer(declaration);
      print("======" + method.methodName + "======");
      print("${method.parametersReport}");
      // print("parameters declaration: ${method.parametersDeclaration}");
      // print(method.positionalParameters);
      // print("named parameters: ${method.namedParameters}");
      // print("parameters texts:\t\t\t${method.parametersTexts}");
      // print("parameters names:\t\t\t${method.parametersNames}");
      // print("parameters data types:\t\t${method.parametersDataTypes}");
      // print("parameters declarations:\t${method.parametersDeclarations}");
    }
  });

  /*
  a.simpleGeneralRun(
    positionals: {
      #thirdTest: [3, 8],
      #fifthTest: ["Princess", 40]
    },
    named: {
      #fourthTest: {
        #name: "Princess Caoline",
        #age: 32
      },
      #fifthTest: {
        #lastName: "Caroline",
      }
    },
  );
   */
}
